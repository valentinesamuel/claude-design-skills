#!/usr/bin/env node
// Two deterministic checks the pipeline otherwise relies on a model to perform:
//   1. hardcoded design values in application source that should be tokens
//   2. tokens declared in the approved prototype theme but absent from production
// Usage: node .claude/scripts/token-diff.mjs [--src src] [--theme src/styles/theme.css]
//        [--prototype .claude/.artifacts/design/features/<slug>/prototype/theme.css]
import { readFileSync, existsSync, readdirSync, statSync } from 'node:fs';
import { join, extname } from 'node:path';

const arg = (flag, def) => { const i = process.argv.indexOf(flag); return i > -1 ? process.argv[i + 1] : def; };
const SRC = arg('--src', 'src');
const THEME = arg('--theme', 'src/styles/theme.css');
const PROTO = arg('--prototype', null);
const EXT = new Set(['.ts', '.tsx', '.js', '.jsx', '.css']);
const SKIP = new Set(['node_modules', 'dist', 'build', '.git', 'coverage']);

// Values that are legitimately literal and must not be flagged.
const ALLOW = [
  /^0$/, /^0px$/, /^1px$/,          // hairlines and zero
  /^100%$/, /^50%$/, /^auto$/,
  /^transparent$/, /^currentColor$/, /^inherit$/, /^none$/,
];
const isAllowed = v => ALLOW.some(r => r.test(v.trim()));

function walk(dir, out = []) {
  if (!existsSync(dir)) return out;
  for (const e of readdirSync(dir)) {
    if (SKIP.has(e)) continue;
    const p = join(dir, e);
    if (statSync(p).isDirectory()) walk(p, out);
    else if (EXT.has(extname(e))) out.push(p);
  }
  return out;
}

const findings = [];
const push = (file, line, kind, value, text) =>
  findings.push({ file, line, kind, value, text: text.trim().slice(0, 90) });

for (const file of walk(SRC)) {
  const isTheme = file.replace(/\\/g, '/').endsWith(THEME.replace(/\\/g, '/'));
  const lines = readFileSync(file, 'utf8').split('\n');
  lines.forEach((text, i) => {
    const n = i + 1;
    if (/^\s*(\/\/|\*|\/\*)/.test(text)) return;
    if (/eslint-disable|token-diff-ignore/.test(text)) return;

    // Hex colours — never legitimate outside the theme layer.
    if (!isTheme) for (const m of text.matchAll(/#[0-9a-fA-F]{3,8}\b/g)) push(file, n, 'hex colour', m[0], text);

    // Raw colour functions outside the theme layer.
    if (!isTheme) for (const m of text.matchAll(/\b(rgb|rgba|hsl|hsla|oklch)\(\s*[^)]*\)/g)) {
      if (!/var\(--/.test(m[0])) push(file, n, 'raw colour', m[0], text);
    }

    // Tailwind arbitrary values: text-[13px], p-[19px], gap-[7px], rounded-[11px] ...
    for (const m of text.matchAll(/\b(?:[a-z-]+)-\[([^\]]+)\]/g)) {
      const v = m[1];
      if (isAllowed(v)) continue;
      if (/^var\(--/.test(v)) continue;                 // arbitrary value pointing at a token is fine
      if (/^(calc|min|max|clamp)\(/.test(v)) continue;  // computed layout is not a design token
      if (/^\d+(\.\d+)?(px|rem|em|pt)$/.test(v) || /^#|^(rgb|hsl|oklch)\(/.test(v))
        push(file, n, 'arbitrary value', m[0], text);
    }

    // Inline style objects with literal dimensions.
    if (/style=\{\{/.test(text)) for (const m of text.matchAll(/(margin|padding|gap|fontSize|borderRadius|width|height|top|left|right|bottom)\w*\s*:\s*['"`]?(\d+(?:\.\d+)?(?:px|rem|em))/g))
      push(file, n, 'inline style', `${m[1]}: ${m[2]}`, text);

    // CSS declarations with literal design values, outside the theme layer.
    if (!isTheme && extname(file) === '.css')
      for (const m of text.matchAll(/\b(margin|padding|gap|font-size|border-radius|line-height|box-shadow)[a-z-]*\s*:\s*([^;{}]+)/g)) {
        const v = m[2];
        if (/var\(--/.test(v) || isAllowed(v)) continue;
        if (/^\s*\d+(\.\d+)?(px|rem|em)/.test(v)) push(file, n, 'css literal', `${m[1]}: ${v.trim()}`, text);
      }

    // Transition/animation durations should come from motion tokens.
    if (!isTheme) for (const m of text.matchAll(/\b(?:duration-\[|transition[^;]*?)(\d{2,4})ms/g))
      push(file, n, 'literal duration', `${m[1]}ms`, text);

    // z-index should be a named scale.
    if (!isTheme) for (const m of text.matchAll(/\bz-\[(\d+)\]|z-index\s*:\s*(\d+)/g)) {
      const v = m[1] || m[2];
      if (Number(v) > 10) push(file, n, 'magic z-index', v, text);
    }
  });
}

// --- token parity between the approved prototype theme and production ---
const tokensIn = f => {
  if (!f || !existsSync(f)) return null;
  return new Set([...readFileSync(f, 'utf8').matchAll(/(--[a-z0-9-]+)\s*:/g)].map(m => m[1]));
};
const prodTokens = tokensIn(THEME);
const protoTokens = tokensIn(PROTO);
let missing = [];
if (protoTokens && prodTokens) {
  missing = [...protoTokens].filter(t => !prodTokens.has(t)).sort();
}

// --- report ---
const byKind = findings.reduce((a, f) => ((a[f.kind] ||= []).push(f), a), {});
if (findings.length === 0) {
  console.log(`ok    no hardcoded design values found under ${SRC}/`);
} else {
  for (const [kind, list] of Object.entries(byKind)) {
    console.log(`\n${kind.toUpperCase()} — ${list.length}`);
    for (const f of list) console.log(`  ${f.file}:${f.line}  ${f.value}\n      ${f.text}`);
  }
}
if (!prodTokens) console.log(`\nWARN  theme not found at ${THEME} — token parity not checked`);
else if (!protoTokens) console.log(`\nWARN  no --prototype theme given — token parity not checked`);
else if (missing.length) {
  console.log(`\nMISSING TOKENS — ${missing.length} declared in the approved prototype but absent from ${THEME}`);
  for (const t of missing) console.log(`  ${t}`);
} else console.log(`ok    all ${protoTokens.size} prototype tokens present in production theme`);

const failures = findings.length + missing.length;
console.log(`\n${failures ? `${findings.length} hardcoded value(s), ${missing.length} missing token(s)` : 'token discipline clean'}`);
process.exit(failures ? 1 : 0);
