-- Set options by buffer.
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2

-- Enable custom indentation function.
-- vim.bo.indentexpr = "v:lua.require('indent.html')()"

-- Not effective when using treesitter indentation.
vim.g.html_indent_script1 = 'inc'
vim.g.html_indent_style1 = 'inc'
