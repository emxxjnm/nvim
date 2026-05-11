# Plugin Loading Strategies

## Immediate (NN-prefix)

Files prefixed with `01-`, `02-`, etc. load synchronously at startup in numeric order, before other plugin files.
Use for: colorscheme, critical global state that other plugins depend on.

Example: `01-colorscheme.lua`, `02-snacks.lua`

## Immediate (no prefix)

Files without a numeric prefix load at startup in alphabetical order, after NN-prefixed files.
Use for: autocmds, keymaps, and other config that runs unconditionally at startup.

Example: `autocmds.lua`, `keymaps.lua`

## vim.schedule

Deferred to after startup completes (next event loop tick).
Use for: plugins needed early but not blocking startup render.

Example: `editing.lua` (ts-comments, surround), `ui.lua` (lualine, noice)

## Autocmd-once

Triggered by a specific event, loads once then removes itself.
Use for: plugins only needed when a condition is met (file opened, insert mode entered).

Example: `lsp.lua` (BufReadPost), `editing.lua` autopairs (InsertEnter)

## Keymap-trigger

A keymap that loads the plugin on first use, then replaces itself.
Use for: plugins with no passive behavior, only activated by user action.

Example: `explorer.lua` (C-n triggers neo-tree load)
