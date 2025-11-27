---@param opts GHActions.TS.Opts
local function setup(opts)
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
end

return { setup = setup }
