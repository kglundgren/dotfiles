--== Options ==--
local opts = {
    expandtab = true,
    shiftwidth = 4,
    softtabstop = 4,
    tabstop = 8,
    number = true,
    relativenumber = true,
    shell = 'pwsh'
} 
for k,v in pairs(opts) do
    -- vim.notify(k .. " = " .. tostring(v)) -- print messages to nvim console
    vim.opt[k] = v
end

vim.cmd('colorscheme retrobox')


--== Keybindings ==--

-- Set leader key to space.
vim.g.mapleader = ' '

local map = vim.api.nvim_set_keymap
local map_opts = { noremap = true, silent = true }

map('v', 'p', '"_dP', map_opts)
map('n', '<leader>l', ':set nohlsearch!<CR>', map_opts)

-- Copy and paste with Ctrl+C Ctrl+V.
map('v', '<C-c>', '"+y', map_opts)
map('v', '<C-v>', '"_d"+P', map_opts)
map('n', '<C-c>', '"+yy', map_opts)
map('n', '<C-v>', '"+p', map_opts)
map('n', '<leader>t', ':belowright 15split | terminal<CR>i', map_opts)
map('n', '<C-w>', ':q<CR>', map_opts)

map('v', '<', '<gv', map_opts)
map('v', '>', '>gv', map_opts)

map('n', '<A-h>', '<C-w>h', map_opts)
map('n', '<A-j>', '<C-w>j', map_opts)
map('n', '<A-k>', '<C-w>k', map_opts)
map('n', '<A-l>', '<C-w>l', map_opts)

-- Terminal mode
map('t', '<C-x>', [[<C-\><C-n>]], map_opts)
map('t', '<A-h>', [[<C-\><C-n><C-w>h]], map_opts)
map('t', '<A-j>', [[<C-\><C-n><C-w>j]], map_opts)
map('t', '<A-k>', [[<C-\><C-n><C-w>k]], map_opts)
map('t', '<A-l>', [[<C-\><C-n><C-w>l]], map_opts)
map('t', '<C-w>', [[<C-\><C-n>:q<CR>]], map_opts)

