# gh-actions.nvim

Plugin that adds support for [Github Actions
expressions][gh-actions-expressions] in Neovim.

![Github Actions Expression syntax highlight](https://github.com/user-attachments/assets/1d098353-a22d-411c-8a4b-1ad97f64132a)

## Features

- Syntax highlighting for Github Actions expressions thanks to
  [`tree-sitter-gh-actions-expressions`][ts-gh-actions-expressions]. Compatible
  with [`^0.3.0`][ts-gh-actions-expressions-version]
- [New predicate](#is-gh-actions-file-predicate)
- [LSP configuration](#lsp-configuration)

## Requirements

- `Neovim >= 0.9.0`
- [`nvim-treesitter`][nvim-treesitter]
- [`gitignore` parser][gitignore] (optional): for `hashFiles()` function
- [`json` parser][json] (optional): for `fromJSON()` function
- [`yaml` parser][yaml]: injection to its `block_mapping_pair` node

## Install

### [`lazy.nvim`](https://github.com/folke/lazy.nvim)

```lua
{
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "Hdoc1509/gh-actions.nvim" },
  config = function()
    -- NOTE: call this before calling `nvim-treesitter.configs.setup()`
    require("gh-actions-expressions.tree-sitter").setup()

    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "gh_actions_expressions", -- required
        "gitignore", -- optional
        "json", -- optional
        "yaml", -- required
      }
    })
  end,
}
```

### [`packer.nvim`](https://github.com/wbthomason/packer.nvim)

```lua
use({
  "nvim-treesitter/nvim-treesitter",
  requires = { "Hdoc1509/gh-actions.nvim" },
  config = function()
    -- NOTE: call this before calling `nvim-treesitter.configs.setup()`
    require("gh-actions-expressions.tree-sitter").setup()

    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "gh_actions_expressions", -- required
        "gitignore", -- optional
        "json", -- optional
        "yaml", -- required
      }
    })
  end,
})
```

## `is-gh-actions-file?` predicate

Check if the buffer matches the pattern `.github/workflows/*.ya?ml`.

## LSP configuration

The `gh-actions-expressions.ts-query-ls` module exports a configuration for
`ts_query_ls` server in order to register the custom `is-gh-actions-file?`
predicate used by this plugin.

> [!NOTE]
> This is only needed if you will use the `is-gh-actions-file?` predicate in
> your queries.

### [nvim-lspconfig][lspconfig] + neovim < 0.11

> [!IMPORTANT]
> Be sure to set `gh-actions.nvim` as a dependency

```lua
local lspconfig = require('lspconfig')
local gh_actions_expressions_ts_query_ls = require('gh-actions-expressions.ts-query-ls')

lspconfig.ts_query_ls.setup(vim.tbl_deep_extend('force', {
  -- your settings
}, gh_actions_expressions_ts_query_ls))
```

### [vim.lsp.config][vim-lsp-config] + neovim >= 0.11

<!-- TODO: need to check if it works correctlty -->

```lua
local gh_actions_expressions_ts_query_ls = require('gh-actions-expressions.ts-query-ls')

vim.lsp.config('ts_query_ls', vim.tbl_deep_extend('force', {
  -- your settings
}, gh_actions_expressions_ts_query_ls))
vim.lsp.enable('ts_query_ls')
```

### `<rtp>/lsp/ts_query_ls.lua` + neovim >= 0.11

<!-- TODO: need to check if it works correctlty -->

<!-- prettier-ignore -->
> [!IMPORTANT]
> `<rtp>` is your [`runtimepath`][rtp]

```lua
local gh_actions_expressions_config = require('gh-actions-expressions.ts-query-ls')

return vim.tbl_deep_extend('force', {
  -- your settings
}, gh_actions_expressions_config)
```

Then, in your `init.lua`:

```lua
vim.lsp.enable('ts_query_ls')
```

## Troubleshooting

> [!IMPORTANT]
> Be sure to run `:checkhealth vim.treesitter` before checking the following
> errors.

### Incompatible ABI version

If you found the following error:

```checkhealth
- ERROR Parser "gh_actions_expressions" failed to load
  (path: .../gh_actions_expressions.so): ...: ABI version mismatch for
  .../gh_actions_expressions.so: supported between X and Y, found Z
```

<!-- prettier-ignore -->
> [!NOTE]
> `X` and `Y` are the interval of ABI versions supported by neovim. `Z` is the
> ABI version that was used to develop the parser.

Be sure to install the following tools:

- [`Node.js`][nodejs]
- [`tree-sitter cli`][tree-sitter-cli]

## Updates

This plugin will follow changes of `tree-sitter-gh-actions-expressions`:

- [ABI version][ts-gh-actions-expressions-title]
- [`queries`][ts-gh-actions-expressions-queries] updates
- [`grammar`][ts-gh-actions-expressions-grammar] updates

[ts-gh-actions-expressions]: https://github.com/hdoc1509/tree-sitter-gh-actions-expressions
[ts-gh-actions-expressions-title]: https://github.com/hdoc1509/tree-sitter-gh-actions-expressions#tree-sitter-gh-actions-expressions
[ts-gh-actions-expressions-grammar]: https://github.com/hdoc1509/tree-sitter-gh-actions-expressions/tree/master/grammar.js
[ts-gh-actions-expressions-queries]: https://github.com/hdoc1509/tree-sitter-gh-actions-expressions/tree/master/queries
[ts-gh-actions-expressions-version]: https://github.com/Hdoc1509/tree-sitter-gh-actions-expressions/blob/master/CHANGELOG.md#030
[gitignore]: https://github.com/shunsambongi/tree-sitter-gitignore
[json]: https://github.com/tree-sitter/tree-sitter-json
[yaml]: https://github.com/tree-sitter-grammars/tree-sitter-yaml
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[nodejs]: https://nodejs.org/en/download
[tree-sitter-cli]: https://github.com/tree-sitter/tree-sitter/tree/master/crates/cli
[lspconfig]: (https://github.com/neovim/nvim-lspconfig)
[gh-actions-expressions]: https://docs.github.com/en/actions/reference/evaluate-expressions-in-workflows-and-actions
[vim-lsp-config]: https://neovim.io/doc/user/lsp.html#lsp-config
[rtp]: https://neovim.io/doc/user/options.html#'runtimepath'
