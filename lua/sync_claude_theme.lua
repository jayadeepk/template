-- Script to sync Claude Code theme with Neovim theme
local M = {}

-- Function to detect current Neovim colorscheme and background
local function get_nvim_theme_info()
  local colorscheme = vim.g.colors_name or "default"
  local background = vim.o.background
  
  return {
    colorscheme = colorscheme,
    background = background,
    is_light = background == "light" or colorscheme:match("light")
  }
end

-- Function to set Claude Code theme
local function set_claude_theme(theme)
  local cmd = string.format("claude config set -g theme %s", theme)
  
  -- Execute command in background to avoid blocking Neovim
  vim.fn.system(cmd)
end

-- Main sync function
function M.sync_claude_theme()
  local theme_info = get_nvim_theme_info()
  -- Use light-daltonized for better white background matching
  local claude_theme = theme_info.is_light and "light-daltonized" or "dark"
  
  -- Set Claude Code theme
  set_claude_theme(claude_theme)
  
  -- Optional: Print confirmation (can be removed for silent operation)
  print(string.format("Synced Claude Code theme to: %s (from Neovim %s/%s)", 
    claude_theme, theme_info.colorscheme, theme_info.background))
end

-- Auto-sync on colorscheme change
function M.setup_auto_sync()
  -- Create autocommand to sync theme when colorscheme changes
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      -- Small delay to ensure theme is fully applied
      vim.defer_fn(M.sync_claude_theme, 100)
    end,
    desc = "Sync Claude Code theme with Neovim colorscheme"
  })
  
  -- Also sync on VimEnter to handle startup
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.defer_fn(M.sync_claude_theme, 500)
    end,
    desc = "Initial Claude Code theme sync on startup"
  })
end

return M