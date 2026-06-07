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
- Servers are turned on in `lua/config/lsp.lua` with `vim.lsp.enable({ ... })`.
- Capabilities (completion, formatting, inline completion, etc.) are wired in the single `LspAttach` autocmd in `lua/config/lsp.lua` — not per-server, not via plugins. Examples already present:
  - **Completion**: `vim.lsp.completion.enable(...)` with `autotrigger`, native `completeopt`.
  - **Formatting**: `BufWritePre` + `vim.lsp.buf.format(...)`.
  - **Inline completion** (Copilot): `vim.lsp.inline_completion.enable(...)` bound to `<Tab>`.

`mason.nvim` is used only to install server binaries, not to configure them.

To add a server: create `lsp/<name>.lua`, add its name to the `vim.lsp.enable({...})` list in `lua/config/lsp.lua`. Ask before installing the binary/package.

## Layout

```
init.lua                 -- entry point: requires each lua/config module, in order
lua/config/
  options.lua            -- vim.o / vim.opt + mapleader
  plugins.lua            -- vim.pack.add, plugin setup() calls, colorscheme
  cheatsheet.lua         -- map() wrapper + :Cheatsheet float (keybind registry)
  keymaps.lua            -- general (non-LSP, non-review) keymaps
  lsp.lua                -- vim.lsp.enable, diagnostics, LspAttach autocmd
  review.lua             -- :Review / :ReviewReset + git review keymaps
lsp/<name>.lua           -- one vim.lsp.Config per server
after/ftplugin/<ft>.lua  -- filetype-local settings/keymaps
nvim-pack-lock.json      -- vim.pack lockfile (do not edit)
```

- `init.lua` is just `require("config.<mod>")` calls. Load order matters: `options` first (sets `mapleader` before any `<leader>` map), `cheatsheet` before any module that calls its `map()` wrapper (`keymaps`, `lsp`, `review`), `plugins` before `review` (review depends on `gitsigns`).
- Config split lives under `lua/config/` — `require("config.x")` resolves `lua/config/x.lua` natively, no plugin manager.
- One file per concern. Put new global behavior in the matching module (a new keymap → `keymaps.lua`, LSP capability → `lsp.lua`); add a new module + `require` in `init.lua` only for a genuinely new concern.
- Filetype-specific behavior goes in `after/ftplugin/<ft>.lua` (buffer-local: `vim.opt_local`, `{ buffer = true }` keymaps).

### Where new code goes

Default: extend an existing module, don't add files. Decide by concern:

- **New option / setting** → `lua/config/options.lua`.
- **New global keymap** (not LSP, not review) → `lua/config/keymaps.lua`. Use the `map()` wrapper from `cheatsheet.lua` (not raw `vim.keymap.set`) with a `desc` so it shows in the cheatsheet — see Cheatsheet.
- **New plugin** → add the URL to `vim.pack.add` and its `setup()` in `lua/config/plugins.lua` (ask first — see Package management). Plugin-specific keymaps: keep with the plugin's `setup()` in `plugins.lua` if tightly coupled, else `keymaps.lua`.
- **New LSP server** → `lsp/<name>.lua` + name in `vim.lsp.enable` (`lua/config/lsp.lua`). New LSP capability/autocmd → the `LspAttach` block in `lua/config/lsp.lua`.
- **New filetype behavior** → `after/ftplugin/<ft>.lua`.

Create a **new `lua/config/<feature>.lua` module only for a genuinely new, self-contained feature** (like `review.lua`) — its own commands/keymaps/autocmds that don't fit the buckets above. When you do: keep it one concern, then `require("config.<feature>")` in `init.lua` at the right point in load order, and document it in this Layout section. Don't pre-split or nest deeper than `lua/config/` without asking.

## Git review

Reviewing changes (e.g. agent-written code) happens **in-editor, natively** — no GitHub round-trip. Built on the built-in quickfix + diff mode, with `gitsigns.nvim` (already in `vim.pack`) for per-file diffs and gutter signs. Lives in `lua/config/review.lua`.

- `:Review [base]` (`<leader>vr`) — populate quickfix with files changed vs the **merge-base** of `base` (default `main`) and HEAD, so unrelated commits on `base` don't leak in. Untracked files are listed too (git diff omits them) as `A`. Sets the gitsigns base globally via `change_base`. This repo's default branch is `master`, so review it with `:Review master`.
- `<leader>vd` — `gitsigns.diffthis` of the current file vs the review base (split diff). Works without `:Review` too — then it diffs vs the git index (uncommitted changes) instead of the merge-base.
- `:ReviewReset` (`<leader>vR`) — clear the review base; signs and `<leader>vd` snap back to the git index.
- `]h` / `[h` — `gitsigns.nav_hunk` next/prev. Native `]c` / `[c` also work inside a diff.
- `require "gitsigns".setup()` is called in `lua/config/plugins.lua` — keep it; the review flow depends on it.

Keep this native. Do **not** swap in diffview.nvim / fugitive / octo.nvim without asking.

## Cheatsheet

A self-documenting keybind cheatsheet. Lives in `lua/config/cheatsheet.lua`. **One source of truth**: the keymap registers itself.

- `cheatsheet.map(mode, lhs, rhs, opts)` is a thin wrapper over `vim.keymap.set`. It sets the map, then — if `opts.desc` is non-empty — records `{ mode, lhs, desc }` in an in-memory registry. Maps with no `desc` are set but not listed (e.g. the auto-pair insert maps), so the sheet stays curated. No built-in/default maps leak in (we only record our own calls).
- `:Cheatsheet` / `<leader>/` toggle a centered floating window listing registered maps, grouped by mode and aligned; `q` / `<Esc>` close.
- Buffer-local maps (`opts.buffer`) are tagged with their bufnr and only listed when that buffer is current — so `after/ftplugin/*` maps show only in their filetype.
- The registry dedups on `mode+lhs+buf`, so per-buffer `ftplugin` re-runs don't pile up.

**Convention: register keymaps via `cheatsheet.map` with a `desc`**, not raw `vim.keymap.set`, so they appear automatically. `local map = require("config.cheatsheet").map` at the top of the module (see `keymaps.lua`, `review.lua`, `after/ftplugin/markdown.lua`; in `lsp.lua` it's required inline inside `LspAttach`). Skip the wrapper only for intentionally-hidden maps (give them no `desc`). Don't build a second list of keybinds anywhere — the registry is it.

## Conventions

- Leader is `<Space>`.
- Indentation: 4 spaces, expandtab (match existing files).
- Register keymaps via the `map()` wrapper from `cheatsheet.lua` (with a `desc`) so they list in the cheatsheet; use `<cmd>...<CR>` style for command maps. Raw `vim.keymap.set` only for maps deliberately kept off the sheet (no `desc`).
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
