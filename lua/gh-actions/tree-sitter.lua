local M = {}

-- see changed features in treesitter section
-- https://neovim.io/doc/user/news-0.10.html#_changed-features
local has_v_0_10 = vim.fn.has("nvim-0.10") == 1
local predicate_options = has_v_0_10 and {} or nil

---@class GhActionsOpts
---@field from_grammar? boolean

---@param opts? GhActionsOpts
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", { from_grammar = false }, opts or {})

  vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.parsers").gh_actions_expressions = {
        ---@diagnostic disable-next-line: missing-fields
        install_info = {
          url = "https://github.com/Hdoc1509/tree-sitter-gh-actions-expressions",
          files = { "src/parser.c" },
          branch = "release",
          requires_generate_from_grammar = opts.from_grammar,
        },
      }
    end
  })

  vim.treesitter.query.add_predicate(
    "is-gh-actions-file?",
    function(_, _, bufnr)
      local filename = vim.api.nvim_buf_get_name(bufnr)

      return filename:match("%.github/workflows/.-%.ya?ml") ~= nil
          or filename:match("tree%-sitter%-gh%-actions%-expressions/README%.md")
          ~= nil
    end,
    ---@diagnostic disable-next-line: param-type-mismatch
    predicate_options
  )
end

return M
