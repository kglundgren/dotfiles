local M = {}

function M.global()
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
end

function M.lsp()
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references)
  vim.keymap.set('n', 'gf', vim.lsp.buf.hover)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)
  vim.keymap.set('n', ']d', vim.lsp.buf.signature_help)

    vim.keymap.set('n', ']d', function()
      vim.diagnostic.jump({ count = vim.v.count1, float = true })
    end, { desc = 'Jump to the next diagnostic in the current buffer' })

    vim.keymap.set('n', '[d', function()
      vim.diagnostic.jump({ count = -vim.v.count1, float = true })
    end, { desc = 'Jump to the previous diagnostic in the current buffer' })

    vim.keymap.set('n', ']D', function()
      vim.diagnostic.jump({ count = math.huge, wrap = false, float = true })
    end, { desc = 'Jump to the last diagnostic in the current buffer' })

    vim.keymap.set('n', '[D', function()
      vim.diagnostic.jump({ count = -math.huge, wrap = false, float = true })
    end, { desc = 'Jump to the first diagnostic in the current buffer' })
end

function M.fzf()
  vim.keymap.set('n', '<C-p>', require('fzf-lua').files, { desc = 'Fzf Files'})
  vim.keymap.set('n', '<leader>f', require('fzf-lua').live_grep, { desc = 'Fzf Grep'})
end

M.fzf_keymap = {
  ['ctrl-q'] = 'select-all+accept',
}


function M.cmp(cmp)
  local luasnip = require 'luasnip'
  vim.keymap.set({"i", "s"}, "<C-L>", function() luasnip.jump( 1) end, {silent = true})
  vim.keymap.set({"i", "s"}, "<C-J>", function() luasnip.jump(-1) end, {silent = true})

  return {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' })
  }
end

return M
