-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'.
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
later(function() require('mini.pairs').setup() end)
later(function() require('mini.icons').setup() end)

-- Icons
later(function() add { source = 'nvim-tree/nvim-web-devicons'} end)

-- Auto-close html tags.
later(function()
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

local map = require('user.map')

-- fzf-lua
later(function()
  add { source = 'ibhagwan/fzf-lua' }
  require('fzf-lua').setup {
    keymap = {
      fzf = map.fzf_keymap
    }
  }
  map.fzf()
end)

-- Snippet engine
now(function()
  add {
    source = 'L3MON4D3/LuaSnip',
    checkout = 'v2.3.0',
    hooks = {
      post_checkout = function(spec)
        vim.notify('spec.path: ' .. spec.path)
        local out = vim.fn.system({'make', 'install_jsregexp'}, {cwd = spec.path})
        vim.notify('result of make install_jsregexp: ' .. out)
      end }
  }
end)

-- Completion/cmp
now(function()
  add {
    source = 'hrsh7th/nvim-cmp',
    depends = {
      'hrsh7th/cmp-nvim-lsp',
      'saadparwaiz1/cmp_luasnip',
      -- 'hrsh7th/cmp-vsnip',
      -- 'hrsh7th/vim-vsnip',
      -- 'hrsh7th/vim-vsnip-integ',
      -- Here we can add vscode snippet plugins, which gets loaded by vsnip.
      -- 'golang/vscode-go'
      -- 'J0rgeSerran0/vscode-csharp-snippets',
    }
  }

  local cmp = require('cmp')
  cmp.setup {
    snippet = {
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- vsnip
        require('luasnip').lsp_expand(args.body) -- luasnip
      end
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert(map.cmp(cmp)) ,
    sources = cmp.config.sources {
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' },
      { name = 'luasnip' },
    }
  }
end)

