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
  local install_info = {
    url = "https://github.com/Hdoc1509/tree-sitter-gh-actions-expressions",
    -- compatibility prior to removal of `files` option:
    -- https://github.com/nvim-treesitter/nvim-treesitter/commit/214cfcf851d95a4c4f2dc7526b95ce9d31c88a76
    files = { "src/parser.c" },
    branch = "release",
    requires_generate_from_grammar = opts.from_grammar,
  }

  if ts_parsers.get_parser_configs ~= nil then
    -- old `master` branch:
    local parser_configs = ts_parsers.get_parser_configs()
    ---@diagnostic disable-next-line: inject-field
    parser_configs.gh_actions_expressions = { install_info = install_info }
  elseif ts_parsers.configs ~= nil then
    -- reference: https://github.com/nvim-treesitter/nvim-treesitter/commit/692b051b09935653befdb8f7ba8afdb640adf17b
    ts_parsers.configs.gh_actions_expression = { install_info = install_info }
  else
    -- reference: https://github.com/nvim-treesitter/nvim-treesitter/commit/c17de5689045f75c6244462182ae3b4b62df02d9
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = function()
        ts_parsers.gh_actions_expressions = { install_info = install_info }
      end,
    })
  end

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
