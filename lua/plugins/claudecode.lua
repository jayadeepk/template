return {
  {
    "cxwx/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    lazy = false,
    config = function()
      require("claudecode").setup({
        terminal_cmd = "claude --dangerously-skip-permissions",
      })
      
      -- Auto-open Claude Code on startup and focus it
      vim.api.nvim_create_autocmd("UIEnter", {
        callback = function()
          vim.defer_fn(function()
            vim.cmd("ClaudeCode")
          end, 300)
        end,
        desc = "Auto-open Claude Code on startup",
      })
    end,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    },
  },
}