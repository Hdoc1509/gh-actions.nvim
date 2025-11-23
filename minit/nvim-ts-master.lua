--# selene: allow(mixed_table)
-- BOOTSTRAP -- DO NOT CHANGE
local bootstrap_cmd =
  "curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"
vim.env.LAZY_STDPATH = "~/.repro/gh-actions.nvim"
load(vim.fn.system(bootstrap_cmd))()
-- BOOTSTRAP -- DO NOT CHANGE

-- NOTE: update config below to match your use case
require("lazy.minit").repro({
  spec = {
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      lazy = false,
      build = ":TSUpdate",
      dependencies = {
        {
          "Hdoc1509/gh-actions.nvim",
          -- branch = "branch",
          -- version = '*',
        },
      },
      config = function()
        require("gh-actions.tree-sitter").setup({
          from_grammar = true,
        })

        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "gh_actions_expressions", "yaml" },
          highlight = { enable = true },
        })
      end,
    },
  },
})
