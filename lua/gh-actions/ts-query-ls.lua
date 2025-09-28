local M = {}

M.expressions = {
  settings = {
    valid_predicates = {
      ["is-gh-actions-file"] = {
        parameters = {
          { type = "string", arity = "optional" },
        },
        description = "Check if the buffer matches the pattern `.github/workflows/*.ya?ml`.",
      },
    },
  },
}

return M
