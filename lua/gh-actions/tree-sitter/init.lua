local M = {}

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

  require("gh-actions.tree-sitter.parser-info").setup(opts)
  require("gh-actions.tree-sitter.predicates").setup()
end

return M
