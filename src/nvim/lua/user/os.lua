local M = {}

M.is_windows = vim.loop.os_uname().sysname == 'Windows_NT'

return M
