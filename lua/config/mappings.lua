-- Terminal mode mappings
-- Exit terminal insert mode with Ctrl+; instead of Ctrl+\+n
vim.keymap.set("t", "<C-]>", "<C-\\><C-n>", { desc = "Exit terminal insert mode" })

-- Paste from clipboard in terminal mode using Ctrl+V
vim.keymap.set("t", "<C-v>", '<C-\\><C-n>"+pi', { desc = "Paste from clipboard in terminal" })


