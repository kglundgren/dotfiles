local MiniDeps = require('mini.deps')
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  add {
    source = 'neovim/nvim-lspconfig',
    depends = { 'williamboman/mason-lspconfig.nvim', 'williamboman/mason.nvim' }
  }

  require('mason').setup()
  require('mason-lspconfig').setup {
    ensure_installed = { 'lua_ls' }
  }

  local on_lsp_attach = function(client, bufnr)
    local client_name = client.name or 'unknown'
    print('LSP ' .. client_name .. ' attached to bufnr ' .. bufnr)

    -- Disable syntax highlighting from LSP and leave it to treesitter.
    -- client.server_capabilities.semanticTokensProvider = nil

    -- Settings for specific LSPs.
    -- if client_name == 'lua_ls' then
    -- end
  end

  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  require('mason-lspconfig').setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler
      require('lspconfig')[server_name].setup {
        on_attach = on_lsp_attach,
        capabilities = capabilities
      }
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for `lua_ls`:
    ['lua_ls'] = function()
      require('lspconfig').lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } }
          }},
        on_attach = on_lsp_attach,
        capabilities = capabilities
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
        on_attach = on_lsp_attach,
        capabilities = capabilities
      }
    end,
  }

  -- Setup LSP keybindings.
  require('user.map').lsp()
end)
