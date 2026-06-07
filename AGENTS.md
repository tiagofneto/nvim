# AGENTS.md

Instructions for coding agents working on this Neovim config.

## Philosophy

This config is **minimal, native-first, modern, and performant**. Read these rules as hard constraints, not suggestions.

- **Native over plugins.** If Neovim can do it natively, do it natively. Never add a plugin for something a small Lua script or built-in feature can handle.
- **Lean.** Prefer a few lines of clear Lua over a dependency. Less code, fewer moving parts.
- **100% Lua. No Vimscript, ever.** Every line of config is Lua — `vim.*` APIs, `vim.lsp`, `vim.pack`, `vim.diagnostic`, autocmds via `vim.api.nvim_create_autocmd`. No `.vim` files, no `vim.cmd([[...]])` blocks of Vimscript. If something seems to need Vimscript, find the Lua API for it.
- **Performant.** Favor lazy, event-driven setup. Avoid anything that adds startup cost without clear payoff.

When in doubt, choose the option that adds the least surface area.

## Neovim version

- Target version: **0.12.2** (LuaJIT 2.1). The user always runs very new Neovim.
- **Always verify against the docs for THIS version.** Your training data is likely outdated for native APIs (`vim.pack`, `vim.lsp`, `vim.lsp.completion`, `vim.lsp.inline_completion`, etc.). Do not trust memory.
  - Check `:help <topic>` content via the local runtime, or the Neovim docs/source for the matching version. Prefer `:h` references.
  - If the user changes version, they update this file. Until then assume 0.12.2.

## Package management

- **Package manager is native `vim.pack`** (added in `init.lua` via `vim.pack.add({...})`). Do not introduce lazy.nvim, packer, or any other manager.
- The lockfile is `nvim-pack-lock.json` — managed by `vim.pack`, do not hand-edit.
- **Ask the user before installing ANY package.** No exceptions.
- If a package is genuinely needed, propose one that is:
  - modern, Lua-based, high performance, OR
  - a well-established community standard.
  - The user trusts agent judgment here but the bar is high — justify why native can't do it.

## LSP

LSP is **fully native, no plugins** (no nvim-lspconfig, no mason-lspconfig glue). Pattern:

- Each server gets a file at `lsp/<name>.lua` returning a `vim.lsp.Config` table.
- Base config is copied from https://github.com/neovim/nvim-lspconfig (the `lsp/` configs there), then trimmed/tweaked for the user's needs. Keep the `---@brief` doc header when copied.
- Servers are turned on in `init.lua` with `vim.lsp.enable({ ... })`.
- Capabilities (completion, formatting, inline completion, etc.) are wired in the single `LspAttach` autocmd in `init.lua` — not per-server, not via plugins. Examples already present:
  - **Completion**: `vim.lsp.completion.enable(...)` with `autotrigger`, native `completeopt`.
  - **Formatting**: `BufWritePre` + `vim.lsp.buf.format(...)`.
  - **Inline completion** (Copilot): `vim.lsp.inline_completion.enable(...)` bound to `<Tab>`.

`mason.nvim` is used only to install server binaries, not to configure them.

To add a server: create `lsp/<name>.lua`, add its name to the `vim.lsp.enable({...})` list. Ask before installing the binary/package.

## Layout

```
init.lua                 -- options, keymaps, pack.add, plugin setup, diagnostics, LspAttach
lsp/<name>.lua           -- one vim.lsp.Config per server
after/ftplugin/<ft>.lua  -- filetype-local settings/keymaps
nvim-pack-lock.json      -- vim.pack lockfile (do not edit)
```

- Filetype-specific behavior goes in `after/ftplugin/<ft>.lua` (buffer-local: `vim.opt_local`, `{ buffer = true }` keymaps).
- Global options, keymaps, and plugin setup stay in `init.lua`.

## Git review

Reviewing changes (e.g. agent-written code) happens **in-editor, natively** — no GitHub round-trip. Built on the built-in quickfix + diff mode, with `gitsigns.nvim` (already in `vim.pack`) for per-file diffs and gutter signs. Lives in `init.lua`.

- `:Review [base]` (`<leader>vr`) — populate quickfix with files changed vs the **merge-base** of `base` (default `master`) and HEAD, so unrelated commits on `base` don't leak in. Sets the gitsigns base globally via `change_base`.
- `<leader>vd` — `gitsigns.diffthis` of the current file vs the review base (split diff). Works without `:Review` too — then it diffs vs the git index (uncommitted changes) instead of the merge-base.
- `:ReviewReset` (`<leader>vR`) — clear the review base; signs and `<leader>vd` snap back to the git index.
- `]h` / `[h` — `gitsigns.nav_hunk` next/prev. Native `]c` / `[c` also work inside a diff.
- `require "gitsigns".setup()` is called in the plugin setup block — keep it; the review flow depends on it.

Keep this native. Do **not** swap in diffview.nvim / fugitive / octo.nvim without asking.

## Conventions

- Leader is `<Space>`.
- Indentation: 4 spaces, expandtab (match existing files).
- Use `vim.keymap.set` with `<cmd>...<CR>` style for command maps.
- Keep additions consistent with surrounding code — same idiom, naming, comment density.

## Workflow for agents

1. Before adding anything, ask: can native Neovim do this? If yes, do that.
2. Before any package install, **ask the user**.
3. Verify API usage against Neovim 0.12.2 docs, not memory.
4. Keep it minimal — smallest change that works.

## Living document

**This is a living document — keep it up to date.** As the config evolves (new servers, new patterns, version bumps, new conventions), this file must evolve too.

- When you make a change that affects how the config is structured or operated, update this file in the same change.
- **Always negotiate, ask, or at minimum inform the user before editing this file.** Do not silently rewrite it.
- Treat staleness here as a bug. An out-of-date AGENTS.md is worse than none.
