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

-- Mini modules
now(function() require('mini.pairs').setup() end)
now(function() require('mini.icons').setup() end)

-- Icons
now(function() add { source = 'nvim-tree/nvim-web-devicons'} end)

-- Colorschemes
now(function() add { source = 'kglundgren/vim-colortuner' } end)
now(function() add { source = 'sainnhe/gruvbox-material' } end)
-- now(function() add { source = 'folke/tokyonight.nvim' } end)
-- now(function() add { source = 'sainttttt/flesh-and-blood' } end)
-- now(function() add { source = 'kdheepak/monochrome.nvim'} end)

-- Auto-close html tags.
now(function()
  -- do return end
  add { source = 'windwp/nvim-ts-autotag' }
  require('nvim-ts-autotag').setup {
    opts = {
      -- Defaults
      enable_close = true, -- Auto close tags
      enable_rename = true, -- Auto rename pairs of tags
      enable_close_on_slash = false -- Auto close on trailing </
    },
    -- Also override individual filetype configs, these take priority.
    -- Empty by default, useful if one of the "opts" global settings
    -- doesn't work well in a specific filetype.
    -- per_filetype = {
    --   ["html"] = {
    --     enable_close = false
    --   }
    -- }
  }
end)

-- fzf-lua
-- now(function() add { source = 'ibhagwan/fzf-lua' } end)
later(function()
  add { source = 'ibhagwan/fzf-lua' }
  require('fzf-lua').setup {
    keymap = {
      fzf = {
        ['ctrl-q'] = 'select-all+accept'
      }
    }
  }
  vim.keymap.set('n', '<C-p>', require('fzf-lua').files, { desc = 'Fzf Files'})
  vim.keymap.set('n', '<leader>f', require('fzf-lua').live_grep, { desc = 'Fzf Grep'})
end)

-- Completion
now(function()
  add {
    source = 'hrsh7th/nvim-cmp',
    depends = {
      'hrsh7th/cmp-nvim-lsp'
    }
  }

  local cmp = require('cmp')
  cmp.setup {
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { 'i', 's' })
    },
    sources = cmp.config.sources {
      { name = 'nvim_lsp' },
    }
  }
end)

-- LSP
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
    client.server_capabilities.semanticTokensProvider = nil

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
end)


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
    ensure_installed = {
      'lua',
      'vimdoc',
      'c_sharp',
      'c',
      'powershell',
      'markdown',
      'html',
      'css',
      'python',
      'javascript',
      'typescript',
      'tsx',
    },
    highlight = { enable = true },
    indent = {
      enable = true,
      disable = { 'html' }
    }
  }
end)

