-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        'git', 'clone', '--filter=blob:none',
        'https://github.com/echasnovski/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Setup MiniDeps module.
local MiniDeps = require('mini.deps')
MiniDeps.setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Mini modules.
later(function() require('mini.pairs').setup() end)
now(function() require('mini.icons').setup() end)

-- Colorschemes.
now(function() add { source = 'folke/tokyonight.nvim' } end)
now(function() add { source = 'sainnhe/gruvbox-material' } end)

-- fzf-lua
now(function() add { source = 'ibhagwan/fzf-lua' } end)
later(function() require('fzf-lua').setup {} end)


-- LSP
now(function() add {
    source = 'neovim/nvim-lspconfig',
    depends = { 'williamboman/mason-lspconfig.nvim', 'williamboman/mason.nvim' }
} end)

now(function() require('mason').setup() end)

local on_lsp_attach = function(client, bufnr)
    local client_name = client.name or 'unknown'
    print('LSP ' .. client_name .. ' attached to bufnr ' .. bufnr)

    if client_name == 'lua_ls' then
        client.server_capabilities.semanticTokensProvider = nil -- Disable lua_ls syntax highlighting and leave it to treesitter.
    end
end

now(function() require('mason-lspconfig').setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler
        require('lspconfig')[server_name].setup { on_attach = on_lsp_attach }
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `lua_ls`:
    ['lua_ls'] = function()
        require('lspconfig').lua_ls.setup {
            settings = { Lua = {
                diagnostics = { globals = { 'vim' } }
            }},
            on_attach = on_lsp_attach
        }
    end,
    ['omnisharp'] = function()
        require('lspconfig').omnisharp.setup {
            -- cmd = { 'dotnet', vim.fn.stdpath('data') .. 'mason/packages/omnisharp/libexec/OmniSharp.dll' }
            cmd = {
                "omnisharp",
                "--languageserver",
                "--hostPID",
                tostring(vim.fn.getpid())
            },
            on_attach = on_lsp_attach
        }
    end
} end)

now(function() require('mason-lspconfig').setup {
    ensure_installed = {
        'lua_ls'
    }
} end)

-- Could be used to manually setup LSPs.
-- But for now we use the automatic setup above, in setup_handlers.
-- later(function()
    -- 	local lspconfig = require('lspconfig')
    -- end)


-- Treesitter
later(function()
    add {
        source = 'nvim-treesitter/nvim-treesitter',
        -- Use 'master' while monitoring updates in 'main'
        checkout = 'master',
        monitor = 'main',
        -- Perform action after every checkout
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    }
    -- Possible to immediately execute code which depends on the added plugin
    require('nvim-treesitter.configs').setup {
        ensure_installed = { 'lua', 'vimdoc', 'c_sharp', 'c' },
        highlight = { enable = true },
    }
end)

