-- Terminal mode mappings
-- Exit terminal insert mode with Ctrl+; instead of Ctrl+\+n
vim.keymap.set("t", "<C-]>", "<C-\\><C-n>", { desc = "Exit terminal insert mode" })

-- Paste from clipboard in terminal mode using Ctrl+V
vim.keymap.set("t", "<C-v>", '<C-\\><C-n>"+pi', { desc = "Paste from clipboard in terminal" })

-- Custom mapping: Ctrl+B to toggle Neo-tree (overrides default page-up)
vim.keymap.set("n", "<C-b>", "<Cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree file explorer" })

-- Git diff shortcuts for diffview.nvim
vim.keymap.set("n", "<Leader>gv", "<Cmd>DiffviewOpen<CR>", { desc = "Open git diff view" })
vim.keymap.set("n", "<Leader>gV", "<Cmd>DiffviewClose<CR>", { desc = "Close git diff view" })
vim.keymap.set("n", "<Leader>gh", "<Cmd>DiffviewFileHistory %<CR>", { desc = "Git file history" })
vim.keymap.set("n", "<Leader>gH", "<Cmd>DiffviewFileHistory<CR>", { desc = "Git branch history" })


