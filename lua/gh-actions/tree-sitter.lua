local M = {}

-- see changed features in treesitter section
-- https://neovim.io/doc/user/news-0.10.html#_changed-features
local has_v_0_10 = vim.fn.has("nvim-0.10") == 1
local predicate_options = has_v_0_10 and {} or nil

---@class GHActions.TS.Opts
---Whether to `generate` files from the grammar before building it
---@field from_grammar? boolean
---Path to local `tree-sitter-gh-actions-expressions`. If set, `url`, `revision` and `branch` options are ignored
---@field path? string
---Remote url to `tree-sitter-gh-actions-expressions`
---@field url? string
---Version or commit of `tree-sitter-gh-actions-expressions`. If set, `branch` option is ignored.
---@field revision? string
---Branch of `tree-sitter-gh-actions-expressions` different from `release`
---@field branch? string

---@type GHActions.TS.Opts
local default_opts = {
  url = "https://github.com/Hdoc1509/tree-sitter-gh-actions-expressions",
  -- TODO: set default `branch` option to `master` once `release` branch has
  -- been deleted from tree-sitter-gh-actions-expressions
  branch = "release",
}

---@param opts? GHActions.TS.Opts
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  local ts_parsers = require("nvim-treesitter.parsers")
  local install_info = {
    url = opts.path or opts.url,
    path = opts.path,
    -- compatibility prior to removal of `files` option:
    -- https://github.com/nvim-treesitter/nvim-treesitter/commit/214cfcf851d95a4c4f2dc7526b95ce9d31c88a76
    files = { "src/parser.c" },
    branch = opts.branch,
    revision = opts.revision,
    generate = opts.from_grammar,
    -- compatibility prior to disuse of `requires_generate_from_grammar` option:
    -- https://github.com/nvim-treesitter/nvim-treesitter/commit/c70daa36dcc2fdae113637fba76350daaf62dba5
    requires_generate_from_grammar = opts.from_grammar,
  }

  local parser_info = {
    install_info = install_info,
    maintainers = { "@Hdoc1509" },
    -- NOTE: set `tier = 1` once parser include wasm artifacts in its releases?
    tier = 3,
  }

  if ts_parsers.get_parser_configs ~= nil then
    -- old `master` branch:
    local parser_configs = ts_parsers.get_parser_configs()
    ---@diagnostic disable-next-line: inject-field
    parser_configs.gh_actions_expressions = parser_info
  elseif ts_parsers.configs ~= nil then
    -- reference: https://github.com/nvim-treesitter/nvim-treesitter/commit/692b051b09935653befdb8f7ba8afdb640adf17b
    ts_parsers.configs.gh_actions_expressions = parser_info
  else
    -- reference: https://github.com/nvim-treesitter/nvim-treesitter/commit/c17de5689045f75c6244462182ae3b4b62df02d9
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = function()
        require("nvim-treesitter.parsers").gh_actions_expressions = parser_info
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
