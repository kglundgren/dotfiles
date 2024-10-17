-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out, 'WarningMsg' },
            { '\nPress any key to exit...' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require('lazy').setup({
    spec = {
        -- import your plugins
        { import = 'plugins.treesitter' },
        {
            -- nvim-lspconfig section
            'neovim/nvim-lspconfig',
            config = function()
                local lspconfig = require('lspconfig')
                lspconfig.lua_ls.setup({})
                lspconfig.csharp_ls.setup {}
            end,
            dependencies = {
                -- mason-lspconfig section
                'williamboman/mason-lspconfig.nvim',
                opts = { -- passing 'opts' will automatically call setup(), same as `config = true`
                    ensure_installed = {
                        'lua_ls',
                        -- other language servers
                    },
                    automatic_installation = true,
                },
                dependencies = {
                    -- mason section
                    'williamboman/mason.nvim',
                    config = true, -- automatically calls `require('mason).setup()`
                    -- lazy = false,
                }
            }
        }
        -- { import = 'plugins.anotherplugin' },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { 'retrobox' } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})

