## Commit Regularly

Commit small logical units. Each commit should be one self-contained change:

- Fix one bug per commit.
- Add one feature per commit.
- Refactor one module per commit.

Use descriptive messages where the first line of the commit message follows these styles from history:

```
fix: vimrc syntax error
feat: add linux support to bashrc
docs: update TODO.md to reflect pyvncs working end-to-end
tools: create script to setup ssh agent symlink
```

Prefix with `fix:`, `feat:`, `docs:`, `tools:`, `refactor:` as appropriate.

Where a fix has several parts that are individually useless, that is one commit,
not several — the vimrc added multiple vim packages, the submodules were updated,
and another vim config file was changed to support that and anyone alone leaves
vim not working properly. Split by "does this stand up on its own", not by
file count.

## Learnings & Gotchas

- Sandbox CLI tools can be unexpected reimplementations (`jq` was actually `jaq`, `ls` was `uutils` 0.8.0) with different output/behavior than upstream — verify against official docs/manuals, not sandbox-observed behavior.
- `export VAR=val` in the persistent bash tool shell leaks across every later call in the session — scope overrides per-command (`VAR=val cmd`), never `export`, for scratch/test state like a temp `$HOME`.
- Parallel agents sharing one repo: `git commit` with no pathspec commits the entire index, not just what you `git add`ed — commit with explicit pathspecs (`git commit -- <files>`) and wrap git calls in a retry-on-`index.lock` helper.
- GNU coreutils (`ls`/`grep`) have no env-var auto-color detection (no BSD `CLICOLOR` equivalent) — `--color=auto` must be injected via alias/flag on every invocation; confirm behavior via official manuals, not local binaries.
- Vim's buffer filetype is resolved before any `-c` startup commands run — test ftdetect/filetype logic with a real vimrc (`-u file`) that enables `filetype plugin indent on` before the buffer loads, not `-u NONE` plus a post-load `-c filetype on`.
- ALE's `g:ale_linters` explicit-mode allowlist needs the literal resolved buffer filetype as a dict key; its filetype-alias table (e.g. `javascriptreact`→`javascript`) only helps linter *discovery*, not the allowlist check.
- Complex inline multi-statement bash one-liners can silently truncate output in this tool harness — write nontrivial verification scripts to a file and execute them for reliable results.
