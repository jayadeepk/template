-- Test file to verify number and sign columns
vim.api.nvim_create_user_command("TestColumns", function()
  print("Current window settings:")
  print("  number: " .. tostring(vim.wo.number))
  print("  relativenumber: " .. tostring(vim.wo.relativenumber))
  print("  signcolumn: " .. vim.wo.signcolumn)
  print("\nGlobal settings:")
  print("  number: " .. tostring(vim.o.number))
  print("  relativenumber: " .. tostring(vim.o.relativenumber))
  print("  signcolumn: " .. vim.o.signcolumn)
end, {})

-- Force enable columns for current window
vim.api.nvim_create_user_command("EnableColumns", function()
  vim.wo.number = true
  vim.wo.relativenumber = true
  vim.wo.signcolumn = "yes"
  print("Columns enabled for current window")
end, {})