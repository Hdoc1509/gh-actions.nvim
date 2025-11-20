# gh-actions.nvim

Plugin that improves support for [Github Actions][gh-actions-docs] files
in Neovim.

![Github Actions Expression syntax highlight](https://github.com/user-attachments/assets/1d098353-a22d-411c-8a4b-1ad97f64132a)

## Features

- Syntax highlighting for Github Actions expressions thanks to
  [`tree-sitter-gh-actions-expressions`][ts-gh-actions-expressions]. Compatible
  with [`^0.3.0`][ts-gh-actions-expressions-version]
- [New predicate](#is-gh-actions-file-predicate) with its [LSP
  configuration](#lsp-configuration)

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
  branch = 'main',
  dependencies = { "Hdoc1509/gh-actions.nvim" },
  config = function()
    -- NOTE: register parser before installation
    require("gh-actions.tree-sitter").setup()

    require("nvim-treesitter").install({
      "gh_actions_expressions", -- required
      "gitignore", -- optional
      "json", -- optional
      "yaml", -- required
    })
  end,
}
```

### [`packer.nvim`](https://github.com/wbthomason/packer.nvim)

```lua
use({
  "nvim-treesitter/nvim-treesitter",
  branch = 'main',
  requires = { "Hdoc1509/gh-actions.nvim" },
  config = function()
    -- NOTE: register parser before installation
    require("gh-actions.tree-sitter").setup()

    require("nvim-treesitter").install({
      "gh_actions_expressions", -- required
      "gitignore", -- optional
      "json", -- optional
      "yaml", -- required
    })
  end,
})
```

### Parser installation for previous `nvim-treesitter` versions

<details>
  <summary>Click to expand</summary>

#### `ensure_install` of `main` branch

```lua
require("nvim-treesitter").setup({
  ensure_install = {
    "gh_actions_expressions", -- required
    "gitignore", -- optional
    "json", -- optional
    "yaml", -- required
  }
})
```

#### `configs` module of old `master` branch

```lua
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "gh_actions_expressions", -- required
    "gitignore", -- optional
    "json", -- optional
    "yaml", -- required
  }
})
```

</details>

## `is-gh-actions-file?` predicate

Check if the buffer matches the pattern `.github/workflows/*.ya?ml`.

## LSP configuration

The `gh-actions.ts-query-ls` module exports a configuration for
[`ts_query_ls`][ts-query-ls] server in order to register the custom
`is-gh-actions-file?` predicate used by this plugin.

> [!NOTE]
> This is only needed if you will use the `is-gh-actions-file?` predicate in
> your queries.

### [nvim-lspconfig][lspconfig] + neovim < 0.11

> [!IMPORTANT]
> Be sure to set `gh-actions.nvim` as a dependency

```lua
local lspconfig = require('lspconfig')
local gh_actions = require('gh-actions.ts-query-ls')

lspconfig.ts_query_ls.setup(vim.tbl_deep_extend('force', {
  -- your settings
}, gh_actions.expressions))
```

### [vim.lsp.config][vim-lsp-config] + neovim >= 0.11

<!-- TODO: need to check if it works correctlty -->

```lua
local gh_actions = require('gh-actions.ts-query-ls')

vim.lsp.config('ts_query_ls', vim.tbl_deep_extend('force', {
  -- your settings
}, gh_actions.expressions))
vim.lsp.enable('ts_query_ls')
```

### `<rtp>/lsp/ts_query_ls.lua` + neovim >= 0.11

<!-- TODO: need to check if it works correctlty -->

<!-- prettier-ignore -->
> [!IMPORTANT]
> `<rtp>` is your [`runtimepath`][rtp]

```lua
local gh_actions = require('gh-actions.ts-query-ls')

return vim.tbl_deep_extend('force', {
  -- your settings
}, gh_actions.expressions)
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

1. Install the following tools:

   - [`Node.js`][nodejs]
   - [`tree-sitter cli`][tree-sitter-cli]

2. Add the `from_grammar` option to the `setup` function of the
   `gh-actions.tree-sitter` module:

   ```lua
   require("gh-actions.tree-sitter").setup({ from_grammar = true })
   ```

3. Reload your neovim config.

4. Run `:TSInstall gh_actions_expressions` to re-install the parser with the
   correct ABI version.

### Errors not related to neovim

Check the [Troubleshooting section of
`tree-sitter-gh-actions-expressions`][ts-gh-actions-expressions-troubleshooting].

## Updates

This plugin will follow changes of `tree-sitter-gh-actions-expressions`:

- [`queries`][ts-gh-actions-expressions-queries] updates
- [`grammar`][ts-gh-actions-expressions-grammar] updates

[ts-gh-actions-expressions]: https://github.com/hdoc1509/tree-sitter-gh-actions-expressions
[ts-gh-actions-expressions-grammar]: https://github.com/hdoc1509/tree-sitter-gh-actions-expressions/tree/master/grammar.js
[ts-gh-actions-expressions-queries]: https://github.com/hdoc1509/tree-sitter-gh-actions-expressions/tree/master/queries
[ts-gh-actions-expressions-version]: https://github.com/Hdoc1509/tree-sitter-gh-actions-expressions/blob/master/CHANGELOG.md#030
[ts-gh-actions-expressions-troubleshooting]: https://github.com/Hdoc1509/tree-sitter-gh-actions-expressions#troubleshooting
[gitignore]: https://github.com/shunsambongi/tree-sitter-gitignore
[json]: https://github.com/tree-sitter/tree-sitter-json
[yaml]: https://github.com/tree-sitter-grammars/tree-sitter-yaml
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[nodejs]: https://nodejs.org/en/download
[tree-sitter-cli]: https://github.com/tree-sitter/tree-sitter/tree/master/crates/cli
[lspconfig]: (https://github.com/neovim/nvim-lspconfig)
[gh-actions-docs]: https://docs.github.com/en/actions/reference/workflows-and-actions
[vim-lsp-config]: https://neovim.io/doc/user/lsp.html#lsp-config
[rtp]: https://neovim.io/doc/user/options.html#'runtimepath'
[ts-query-ls]: https://github.com/ribru17/ts_query_ls

<!-- markdownlint-disable-file MD033 -->
