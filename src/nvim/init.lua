local os = require('user.os')

-- Keybindings/maps that do not require external dependencies.
require('user.map').global()

require('user.mini')
require('user.colo')
require('user.lsp')
require('user.ts')
require('user.snippets')
require('user.util')

-- Commands
-- vim.opt: Set list and map-style options.
-- vim.g: Set global editor variables.
-- vim.cmd: Executes an 'ex' command, like 'language en' or 'set path+=**'.
-- vim.cmd('set showtabline=1') -- Show tab-line only if there are at least two tab pages.
vim.cmd('set nowrap') -- No line-wrapping on long lines.

-- Options
local opts = {
  termguicolors = true,
  number = true,
  relativenumber = true,
  mouse = 'a',
  -- Tab/indentation settings
  -- expandtab:     When this option is enabled, vi will use spaces instead of tabs.
  -- tabstop:       Width of tab character.
  -- softtabstop:   Affects the distance moved when pressing <Tab> or <BS>.
  -- shiftwidth:    Affects automatic indentation.
  expandtab = true,
  tabstop = 8,
  softtabstop = 4,
  shiftwidth = 4,
}

-- Conditionally add Windows-specific settings. 
if os.is_windows then
  opts.shell = 'pwsh'
  opts.shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
  opts.shellredir = "2>&1 | %%{ '$_' } | Out-File %s; exit $LastExitCode"
  opts.shellpipe = "2>&1 | %%{ '$_' } | tee %s; exit $LastExitCode"
  opts.shellquote = ''
  opts.shellxquote = ''
  vim.cmd('language messages en') -- Set ui and message language to English.
end

for k, v in pairs(opts) do
  -- vim.notify(k .. " = " .. tostring(v)) -- print messages to nvim console
  vim.opt[k] = v
end

-- Omnisharp
vim.g.OmniSharp_highlighting = 0

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 20

-- Autocmds
-- Treat svelte files as html.
local autocmd = vim.api.nvim_create_autocmd
autocmd('BufEnter', {
  pattern = '*.svelte',
  command = 'set ft=html',
})

-- Set HTML syntax highlighting for .razor files.
autocmd('BufEnter', {
  pattern = '*.razor',
  command = 'set ft=html',
})

