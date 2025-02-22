local MiniDeps = require('mini.deps')
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- now(function() add { source = 'sainttttt/flesh-and-blood' } end)
-- now(function() add { source = 'kdheepak/monochrome.nvim'} end)

-- Plugin for adjusting colorschemes.
-- Used with `:Colortuner`.
later(function() add { source = 'kglundgren/vim-colortuner' } end)

-- gruvbox
local use_gruvbox = true
if use_gruvbox then
  now(function()
    add { source = 'sainnhe/gruvbox-material' }
    -- This configuration option should be placed before `colorscheme gruvbox-material`.
    -- Available values: 'hard', 'medium'(default), 'soft'
    -- Run `:highlight Normal` to figure out the hex codes of the colors.
    vim.g.gruvbox_material_background = 'hard'
    vim.g.gruvbox_material_disable_italic_comment = false
    vim.g.gruvbox_material_transparent_background = 2
    vim.cmd('colo gruvbox-material')
  end)
end

-- tokyonight
local use_tokyonight = false
if use_tokyonight then
  now(function()
    add { source = 'folke/tokyonight.nvim' }
    require('tokyonight').setup {
      styles = {
	comments = { italic = true },
	keywords = { italic = true }
      }
    }
  end)
  vim.cmd('colo tokyonight')
end

