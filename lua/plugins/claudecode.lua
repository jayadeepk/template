return {
  {
    "cxwx/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    lazy = false,
    config = function()
      require("claudecode").setup({
        terminal_cmd = "claude --dangerously-skip-permissions",
      })
      
      -- Auto-open Claude Code on startup and make it the only window
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Only proceed if no files were opened
          if vim.fn.argc() == 0 then
            -- Immediately delete empty buffer and open Claude Code
            vim.schedule(function()
              -- Delete empty buffers immediately
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_valid(buf) then
                  local name = vim.api.nvim_buf_get_name(buf)
                  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                  if name == "" and #lines <= 1 and (lines[1] or "") == "" then
                    pcall(vim.api.nvim_buf_delete, buf, { force = true })
                  end
                end
              end
              
              -- Open Claude Code immediately
              vim.cmd("ClaudeCode")
              
              -- Quick cleanup after Claude Code opens
              vim.defer_fn(function()
                local claude_win = nil
                local claude_buf = nil
                
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  local buf = vim.api.nvim_win_get_buf(win)
                  local bufname = vim.api.nvim_buf_get_name(buf)
                  if bufname:match("claude") then
                    claude_win = win
                    claude_buf = buf
                    break
                  end
                end
                
                if claude_win then
                  -- Close any remaining non-Claude windows
                  for _, win in ipairs(vim.api.nvim_list_wins()) do
                    if win ~= claude_win then
                      pcall(vim.api.nvim_win_close, win, true)
                    end
                  end
                  
                  -- Focus Claude Code window
                  vim.api.nvim_set_current_win(claude_win)
                end
              end, 50)
            end)
          end
        end,
        desc = "Auto-open Claude Code on startup and hide empty buffer",
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