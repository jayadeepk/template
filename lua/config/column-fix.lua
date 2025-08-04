-- Fix for number and sign columns
-- This ensures they are enabled for all normal buffers

-- Set global defaults
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- Create autocmd to ensure columns are enabled for new windows
vim.api.nvim_create_autocmd({"BufWinEnter", "WinEnter"}, {
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(buf)
    local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    
    -- Skip terminal buffers and specific filetypes
    if ft ~= "terminal" and not bufname:match("claude") then
      vim.wo.number = true
      vim.wo.relativenumber = true
      vim.wo.signcolumn = "yes"
    end
  end,
  desc = "Ensure number and sign columns are enabled",
})