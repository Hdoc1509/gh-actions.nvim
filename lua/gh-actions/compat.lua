local M = {}

M.has_0_10 = vim.fn.has("nvim-0.10") == 1

-- see changed features in treesitter section
-- https://neovim.io/doc/user/news-0.10.html#_changed-features
M.predicate_options = M.has_0_10 and {} or nil

return M
