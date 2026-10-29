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
