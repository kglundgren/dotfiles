return function()
  local lnum = vim.v.lnum
  if lnum > 1 then
    local prev_nonblank = vim.fn.prevnonblank(lnum - 1)
    if prev_nonblank > 0 then
      local prev_line = vim.fn.getline(prev_nonblank)
      if prev_line:match("<script.*>") then
        print('using custom indent')
        local base_indent = vim.fn["nvim_treesitter#indent"]()
        return base_indent + vim.bo.shiftwidth
      end
    end
  end

  print('using ts indent')
  return vim.fn["nvim_treesitter#indent"]()
end
