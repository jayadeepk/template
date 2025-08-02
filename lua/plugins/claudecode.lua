return {
  {
    "cxwx/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    lazy = false,
    config = function()
      require("claudecode").setup {
        terminal_cmd = "claude --dangerously-skip-permissions",
      }

      -- Hide terminal title for Claude Code windows
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*claude*",
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          -- Hide the terminal title/buffer name
          vim.api.nvim_buf_set_option(buf, "buflisted", false)
          -- Set window options to hide title
          local win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_option(win, "number", false)
          vim.api.nvim_win_set_option(win, "relativenumber", false)
          vim.api.nvim_win_set_option(win, "signcolumn", "no")
          -- Hide the winbar/title if it exists
          pcall(vim.api.nvim_win_set_option, win, "winbar", "")
        end,
        desc = "Hide terminal title for Claude Code",
      })

      -- Auto-open Claude Code on startup and make it the only window
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Only proceed if no files were opened
          if vim.fn.argc() == 0 then
            -- Start Claude Code loading in the background immediately
            vim.schedule(function() vim.cmd "ClaudeCode" end)

            -- Delay the cleanup to happen after splash screen ends
            vim.defer_fn(function()
              vim.schedule(function()
                local claude_win = nil
                local claude_buf = nil

                -- Find Claude Code window and buffer
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  local buf = vim.api.nvim_win_get_buf(win)
                  local bufname = vim.api.nvim_buf_get_name(buf)
                  if bufname:match "claude" then
                    claude_win = win
                    claude_buf = buf
                    break
                  end
                end

                if claude_win then
                  -- Focus Claude Code window first
                  vim.api.nvim_set_current_win(claude_win)

                  -- Close any remaining non-Claude windows
                  for _, win in ipairs(vim.api.nvim_list_wins()) do
                    if win ~= claude_win then pcall(vim.api.nvim_win_close, win, true) end
                  end

                  -- Clean up unwanted buffers but be more conservative
                  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if buf ~= claude_buf and vim.api.nvim_buf_is_valid(buf) then
                      local name = vim.api.nvim_buf_get_name(buf)
                      local ft = vim.api.nvim_buf_get_option(buf, "filetype")
                      -- Only delete truly empty buffers, not splash or other important buffers
                      if ft ~= "terminal" and (name == "" or name:match "untitled") then
                        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                        if #lines <= 1 and (lines[1] or "") == "" then
                          pcall(vim.api.nvim_buf_delete, buf, { force = true })
                        end
                      end
                    end
                  end
                else
                  -- If Claude Code didn't open properly, create a simple buffer to prevent quit
                  local fallback_buf = vim.api.nvim_create_buf(false, true)
                  vim.api.nvim_set_current_buf(fallback_buf)
                end
              end)
            end, 1000) -- Cleanup immediately after splash screen ends
          end
        end,
        desc = "Auto-open Claude Code on startup and hide empty buffer",
      })

      -- Handle Claude Code buffer closing to prevent fallback to empty buffer
      vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout", "TermClose" }, {
        callback = function(args)
          local bufname = vim.api.nvim_buf_get_name(args.buf)
          if bufname:match "claude" then
            -- When Claude Code buffer is deleted, check if there are any other useful buffers
            vim.defer_fn(function()
              local has_useful_buffer = false
              local empty_bufs = {}

              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
                  local name = vim.api.nvim_buf_get_name(buf)
                  local ft = vim.api.nvim_buf_get_option(buf, "filetype")

                  -- Skip terminal buffers and consider only real file buffers
                  if ft ~= "terminal" and name ~= "" and not name:match "untitled" then
                    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                    if not (#lines <= 1 and (lines[1] or "") == "") then
                      has_useful_buffer = true
                    else
                      table.insert(empty_bufs, buf)
                    end
                  elseif ft ~= "terminal" then
                    table.insert(empty_bufs, buf)
                  end
                end
              end

              -- If no useful buffers remain, exit Neovim instead of showing empty buffer
              if not has_useful_buffer then
                vim.cmd "qall"
              else
                -- Clean up any remaining empty buffers
                for _, buf in ipairs(empty_bufs) do
                  pcall(vim.api.nvim_buf_delete, buf, { force = true })
                end
              end
            end, 100) -- Increased delay
          end
        end,
        desc = "Handle Claude Code buffer deletion",
      })

      -- Alternative approach: Use WinClosed to detect when Claude window is closed
      vim.api.nvim_create_autocmd("WinClosed", {
        callback = function()
          vim.defer_fn(function()
            -- Check if any Claude windows remain
            local claude_windows = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_is_valid(win) then
                local buf = vim.api.nvim_win_get_buf(win)
                local bufname = vim.api.nvim_buf_get_name(buf)
                if bufname:match "claude" then table.insert(claude_windows, win) end
              end
            end

            -- If no Claude windows remain, check for useful buffers
            if #claude_windows == 0 then
              local has_useful_buffer = false
              local empty_bufs = {}

              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
                  local name = vim.api.nvim_buf_get_name(buf)
                  local ft = vim.api.nvim_buf_get_option(buf, "filetype")

                  if ft ~= "terminal" and name ~= "" and not name:match "untitled" then
                    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                    if not (#lines <= 1 and (lines[1] or "") == "") then
                      has_useful_buffer = true
                    else
                      table.insert(empty_bufs, buf)
                    end
                  elseif ft ~= "terminal" then
                    table.insert(empty_bufs, buf)
                  end
                end
              end

              -- If no useful buffers remain, exit Neovim
              if not has_useful_buffer then vim.cmd "qall" end
            end
          end, 100)
        end,
        desc = "Exit when Claude Code window is closed and no useful buffers remain",
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
