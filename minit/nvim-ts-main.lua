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
      branch = "main",
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
        require("gh-actions.tree-sitter").setup()

        require("nvim-treesitter").install({ "gh_actions_expressions", "yaml" })

        -- ensure directory for parsers and queries in `rtp` after first
        -- installation of parsers. DO NOT CHANGE
        vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/site")

        vim.api.nvim_create_autocmd("FileType", {
          pattern = "yaml",
          callback = function()
            pcall(vim.treesitter.start)
          end,
        })
      end,
    },
  },
})
