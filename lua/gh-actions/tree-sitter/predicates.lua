---@type table<string, TSPredicate>
local predicates = {
  ["is-gh-actions-file?"] = function(_, _, source)
    if type(source) ~= "number" then
      return false
    end

    local filename = vim.api.nvim_buf_get_name(source)

    return filename:match("%.github/workflows/.-%.ya?ml") ~= nil
      or filename:match("tree%-sitter%-gh%-actions%-expressions/README%.md")
        ~= nil
  end,
}

local function setup()
  local predicate_options = require("gh-actions.compat").predicate_options

  for name, handler in pairs(predicates) do
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.treesitter.query.add_predicate(name, handler, predicate_options)
  end
end

return { setup = setup }
