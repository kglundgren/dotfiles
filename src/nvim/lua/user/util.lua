local M = {}

function M.tab_opts()
	print(string.format(
		'expandtab: %s, tabstop: %s, softtabstop: %s, shiftwidth: %s\n',
		vim.opt.expandtab:get(),
		vim.opt.tabstop:get(),
		vim.opt.softtabstop:get(),
		vim.opt.shiftwidth:get()
	))
end

-- Enables :TabOpts command in command mode.
vim.api.nvim_create_user_command('TabOpts', M.tab_opts, {})

return M
