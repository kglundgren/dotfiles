local MiniDeps = require('mini.deps')
local add, later = MiniDeps.add, MiniDeps.later

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
      'razor'
    },
    highlight = { enable = true },
    indent = {
      enable = true,
      disable = { 'html' }
    }
  }
end)

