--== Plugins ==--
-- lazy.nvim
-- require("config.lazy")
-- mini
require('config.mini')


local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'


--== Commands ==--
-- vim.opt: Set list and map-style options.
-- vim.g: Set global editor variables.
-- vim.cmd: Executes an 'ex' command, like 'language en' or 'set path+=**'.
-- vim.cmd('set showtabline=1') -- Show tab-line only if there are at least two tab pages.
vim.cmd('set nowrap') -- No line-wrapping on long lines.

-- Set contrast.
-- This configuration option should be placed before `colorscheme gruvbox-material`.
-- Available values: 'hard', 'medium'(default), 'soft'
-- vim.g.gruvbox_material_background = 'medium'
-- vim.g.gruvbox_material_disable_italic_comment = false
-- vim.cmd('colo gruvbox-material')
vim.cmd('colo tokyonight')

--== Options ==--
local opts = {
    termguicolors = true,
    number = true,
    relativenumber = true,
    mouse = 'a',
    -- Tab settings --
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
if is_windows then
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


--== Netrw ==--
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 20


--== Mappings ==--
local map = vim.api.nvim_set_keymap
local map_opts = { noremap = true, silent = true }

-- Leader
-- Set leader key to space.
vim.g.mapleader = ' '

-- Toggle search highlighting.
map('n', '<leader>l', ':set nohlsearch!<CR>', map_opts)

-- Quit with leader+q.
map('n', '<leader>q', ':q<CR>', map_opts)

-- Save with leader-w.
map('n', '<leader>w', ':w<CR>', map_opts)

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

-- Discard (don't yank) the selected text that is pasted over.
-- If you have 'foo' yanked and select 'bar', then pasting over
-- 'bar' would normally yank 'bar' into your registry.
-- This makes it so that 'foo' stays in the reg.
map('v', 'p', '"_dP', map_opts)

-- Move selected line up and down with <A-j/k>.
map('v', '<A-j>', 'dp<S-v>', map_opts)
map('v', '<A-k>', 'dkP<S-v>', map_opts)

-- Copy and paste with Ctrl+C Ctrl+V.
map('v', '<C-c>', '"+y', map_opts)
map('v', '<C-v>', '"_d"+P', map_opts)
map('n', '<C-c>', '"+yy', map_opts)
map('n', '<C-v>', '"+p', map_opts)
map('n', '<leader>t', ':belowright 15split | terminal<CR>i', map_opts)

-- Stay in Visual Mode with the same selection after indenting.
map('v', '<', '<gv', map_opts)
map('v', '>', '>gv', map_opts)

-- Navigate between splits with Alt+HJKL.
map('n', '<A-h>', '<C-w>h', map_opts)
map('n', '<A-j>', '<C-w>j', map_opts)
map('n', '<A-k>', '<C-w>k', map_opts)
map('n', '<A-l>', '<C-w>l', map_opts)

-- Terminal mode
map('t', '<leader>t', '<C-\\><C-n>:q<CR>', map_opts)
map('t', '<A-h>', [[<C-\><C-n><C-w>h]], map_opts)
map('t', '<A-j>', [[<C-\><C-n><C-w>j]], map_opts)
map('t', '<A-k>', [[<C-\><C-n><C-w>k]], map_opts)
map('t', '<A-l>', [[<C-\><C-n><C-w>l]], map_opts)

-- netrw
-- Toggle left-side netrw with <leader>e.
map('n', '<leader>e', ':Lexplore<CR>', map_opts)

-- Change working directory to that of the current file. 
map('n', '<leader>cd', ':cd %:p:h<CR>', map_opts)

-- fzf
vim.keymap.set('n', '<C-p>', require('fzf-lua').files, { desc = 'Fzf Files'})
vim.keymap.set('n', '<C-f>', require('fzf-lua').live_grep, { desc = 'Fzf Grep'})

-- LSP
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', 'gf', vim.lsp.buf.hover)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)


--== Autocmds ==--
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

