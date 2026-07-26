To install

```
curl -fsSL https://raw.githubusercontent.com/valentinesamuel/claude-design-skills/main/scripts/install.sh | bash -s -- [project-path]
```

The six-specialist design pipeline always installs in full — it's one
cohesive system, not something to install partially. On top of it, the
installer offers two independent, optional picks:

- **Roles** — individual subagents (Task-tool agents, not skills) dropped into
  `.claude/agents/`: `ui-designer`, `frontend-developer`, `react-specialist`,
  `code-reviewer`, `qa-expert`, `accessibility-tester`, and others. Pick the
  ones relevant to the work — e.g. `ui-designer` + `frontend-developer` for a
  greenfield build, `code-reviewer` + `qa-expert` for a hardening pass.
- **Industries** — vertical command packs (`/name` slash commands) dropped
  into `.claude/commands/`. `health` is the only one today: 13 domain-expert
  consultants (clinical, nursing, pharmacy, lab, HMO/claims, hospital ops,
  compliance, revenue cycle, healthcare PM/UX/DevOps, data standards). These
  are written project-agnostically — each one's first job is to locate the
  current project's actual types, files, and roles before giving domain
  advice, rather than assuming any specific codebase's structure. Source
  files live under `industries/{name}/commands/` in this repo; adding a new
  industry means adding a new directory there plus one array entry in
  `scripts/install.sh`.

Both are answered interactively at install time, or non-interactively with
`--roles <list>` / `--industries <list>` (comma-separated, or `all`/`none`).
They don't participate in the pipeline state machine documented in
`CLAUDE.md` and aren't re-selectable later without re-running the installer.
