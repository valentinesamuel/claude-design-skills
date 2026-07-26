#!/usr/bin/env node
// Validates .claude/.artifacts/design/manifest.md structural integrity.
// Deterministic checks that must not depend on a model reading carefully.
// Usage: node .claude/scripts/validate-manifest.mjs [--root <path>]
import { readFileSync, existsSync, readdirSync } from 'node:fs';
import { join } from 'node:path';

const argRoot = process.argv.indexOf('--root');
const ROOT = argRoot > -1 ? process.argv[argRoot + 1] : '.claude/.artifacts/design';
const fail = [], warn = [], ok = [];

const STAGES = {
  0: { skill: 'artifact-manager',        modes: ['init','feature','repair','status','archive','audit'] },
  1: { skill: 'senior-product-designer', modes: ['design'] },
  2: { skill: 'design-reviewer',         modes: ['review'] },
  3: { skill: 'ux-reviewer',             modes: ['review'] },
  4: { skill: 'frontend-architect',      modes: ['plan'] },
  5: { skill: 'staff-ui-engineer',       modes: ['implement'] },
  6: { skill: 'frontend-architect',      modes: ['validate'] },
};
const STATUSES = ['not-started','in-progress','awaiting-clarification','awaiting-review','changes-required','blocked','complete'];
const REQUIRED_KEYS = ['Feature','Feature Slug','Stage','Owner','Next Skill','Mode','Status','Iteration','Max Iterations','Open Required Changes','Last Decision','Updated','Review Scope'];
// Artifacts each stage must have produced, checked against stages already passed.
const PRODUCES = {
  1: ['design-analysis.md','design-spec.md','handoff.md','prototype'],
  2: ['design-review.md'],
  3: ['ux-review.md'],
  4: ['architecture-plan.md','component-architecture.md','implementation-guidelines.md','api-contract.md'],
  5: ['implementation-plan.md','implementation-report.md'],
  6: ['validation-report.md'],
};

const manifestPath = join(ROOT, 'manifest.md');
if (!existsSync(manifestPath)) {
  console.error(`FAIL  manifest not found at ${manifestPath}`);
  console.error('      Run /artifact-manager to initialise.');
  process.exit(1);
}
const src = readFileSync(manifestPath, 'utf8');

// --- parse the PIPELINE STATE fenced block ---
const block = src.match(/##\s*PIPELINE STATE\s*```([\s\S]*?)```/);
if (!block) {
  console.error('FAIL  no fenced PIPELINE STATE block found');
  process.exit(1);
}
const state = {};
for (const line of block[1].split('\n')) {
  const m = line.match(/^\s*([A-Za-z ]+?)\s*:\s*(.*?)\s*$/);
  if (m) state[m[1]] = m[2];
}

for (const k of REQUIRED_KEYS) {
  if (!(k in state)) fail.push(`missing state key: ${k}`);
}
if (fail.length) { report(); process.exit(1); }

const stage = Number(state.Stage);
const iter = Number(state.Iteration);
const maxIter = Number(state['Max Iterations']);
const declaredOpen = Number(state['Open Required Changes']);

// --- consistency ---
if (!(stage in STAGES)) fail.push(`Stage ${state.Stage} is not 0-6`);
else {
  const def = STAGES[stage];
  if (state.Owner !== def.skill) fail.push(`Stage ${stage} owner should be ${def.skill}, found ${state.Owner}`);
  if (!def.modes.includes(state.Mode)) fail.push(`Mode "${state.Mode}" invalid for stage ${stage} (expected ${def.modes.join('|')})`);
  else ok.push(`stage ${stage} / ${state.Owner} / ${state.Mode} consistent`);
  if (state['Next Skill'] !== 'none' && state['Next Skill'] !== state.Owner)
    warn.push(`Next Skill (${state['Next Skill']}) differs from Owner (${state.Owner}) — expected only mid-transition`);
}
if (!STATUSES.includes(state.Status)) fail.push(`Status "${state.Status}" not one of: ${STATUSES.join(', ')}`);
if (!['full','delta'].includes(state['Review Scope'])) fail.push(`Review Scope must be full|delta, found "${state['Review Scope']}"`);
if (Number.isNaN(iter) || Number.isNaN(maxIter)) fail.push('Iteration / Max Iterations must be numeric');
else if (iter > maxIter) fail.push(`Iteration ${iter} exceeds Max Iterations ${maxIter} — should be Status: blocked with escalation.md`);
if (state.Status === 'blocked' && state['Next Skill'] !== 'none') fail.push('Status blocked requires Next Skill: none');
if (state['Review Scope'] === 'delta' && iter === 0) warn.push('Review Scope delta on iteration 0 — first review should be full');

// --- open required changes table vs declared count ---
const orcSection = src.split(/##\s*Open Required Changes/)[1] || '';
const orcRows = (orcSection.split(/\n##\s/)[0].match(/^\|(?!\s*[-#])[^\n]*\|$/gm) || [])
  .filter(r => !/^\|\s*#\s*\|/.test(r) && !/^\|\s*-+/.test(r));
const openRows = orcRows.filter(r => !/\bdone\b|\bcleared\b|\bclosed\b/i.test(r));
if (orcRows.length && declaredOpen !== openRows.length)
  fail.push(`Open Required Changes says ${declaredOpen} but table has ${openRows.length} open row(s)`);
else ok.push(`open required changes count matches table (${declaredOpen})`);

// --- feature scope ---
const slug = state['Feature Slug'];
const hasFeature = slug && slug !== 'none';
const FEATURE = hasFeature ? join(ROOT, 'features', slug) : null;

if (hasFeature) {
  if (!existsSync(FEATURE)) fail.push(`feature directory missing: ${FEATURE}`);
  else {
    if (!existsSync(join(FEATURE, 'current-feature.md'))) fail.push('current-feature.md missing');
    if (!existsSync(join(FEATURE, 'clarifications.md'))) fail.push('clarifications.md missing — clarification protocol requires it');
    for (let s = 1; s < stage; s++) {
      for (const a of (PRODUCES[s] || [])) {
        const p = join(FEATURE, a);
        if (!existsSync(p)) fail.push(`stage ${s} artifact missing: ${a} (pipeline is at stage ${stage})`);
        else if (a !== 'prototype' && readFileSync(p, 'utf8').trim().length < 40)
          fail.push(`stage ${s} artifact effectively empty: ${a}`);
      }
    }
    if (stage > 1 && existsSync(join(FEATURE, 'prototype'))) {
      const files = readdirSync(join(FEATURE, 'prototype'));
      if (!files.some(f => f.endsWith('.html'))) fail.push('prototype/ contains no .html — reviewers have nothing to review');
      if (!files.includes('NOTES.md')) warn.push('prototype/NOTES.md missing');
    }
    if (state.Status === 'blocked' && !existsSync(join(FEATURE, 'escalation.md')))
      fail.push('Status blocked but escalation.md missing');
  }
} else if (stage > 0) {
  fail.push(`Stage ${stage} with no Feature Slug`);
}

// --- project-level artifacts ---
for (const a of ['project-context.md','art-direction.md','design-system.md','decisions.md','product-architecture.md']) {
  const p = join(ROOT, a);
  if (!existsSync(p)) fail.push(`project artifact missing: ${a}`);
  else if (stage > 1 && /\{\.\.\.\}/.test(readFileSync(p, 'utf8')))
    fail.push(`${a} still contains unfilled {...} placeholders at stage ${stage}`);
}

// --- decision ids: D-<slug>-<n>, sequential within each feature ---
const decPath = join(ROOT, 'decisions.md');
if (existsSync(decPath)) {
  const ids = [...readFileSync(decPath, 'utf8').matchAll(/^##\s+(D-[a-z0-9-]+?)-(\d+)\b/gm)];
  const byFeature = {};
  for (const [, base, n] of ids) (byFeature[base] ||= []).push(Number(n));
  for (const [base, ns] of Object.entries(byFeature)) {
    ns.sort((a, b) => a - b);
    for (let i = 0; i < ns.length; i++) {
      if (ns[i] !== i + 1) { fail.push(`decision IDs for ${base} not sequential from 1 (gap or duplicate near ${base}-${ns[i]})`); break; }
    }
  }
  const last = state['Last Decision'];
  if (last && last !== 'none' && ids.length && !ids.some(m => `${m[1]}-${m[2]}` === last))
    fail.push(`Last Decision "${last}" not found in decisions.md`);
  if (ids.length) ok.push(`${ids.length} decision(s) with valid sequential IDs`);
}

function report() {
  for (const o of ok)   console.log(`ok    ${o}`);
  for (const w of warn) console.log(`WARN  ${w}`);
  for (const f of fail) console.log(`FAIL  ${f}`);
  console.log('');
  console.log(fail.length
    ? `${fail.length} failure(s), ${warn.length} warning(s) — run /artifact-manager in repair mode`
    : `manifest valid (${warn.length} warning(s))`);
}
report();
process.exit(fail.length ? 1 : 0);
