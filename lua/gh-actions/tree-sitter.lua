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

  local ts_parsers = require("nvim-treesitter.parsers")

  local parser_configs = ts_parsers.get_parser_configs()

  ---@diagnostic disable-next-line: inject-field
  parser_configs.gh_actions_expressions = {
    install_info = {
      url = "https://github.com/Hdoc1509/tree-sitter-gh-actions-expressions",
      files = { "src/parser.c" },
      branch = "release",
      requires_generate_from_grammar = opts.from_grammar,
    },
  }

  ---@param source integer|string
  local function is_gh_actions_file(_, _, source)
    if type(source) ~= "number" then
      return false
    end

    local filename = vim.api.nvim_buf_get_name(source)

    return filename:match("%.github/workflows/.-%.ya?ml") ~= nil
      or filename:match("tree%-sitter%-gh%-actions%-expressions/README%.md")
        ~= nil
  end

  vim.treesitter.query.add_predicate(
    "is-gh-actions-file?",
    is_gh_actions_file,
    ---@diagnostic disable-next-line: param-type-mismatch
    predicate_options
  )
end

return M
