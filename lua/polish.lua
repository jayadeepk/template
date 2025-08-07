-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Load autocmds
require("config.autocmds")

-- Load custom mappings
require("config.mappings")

-- Load test commands
require("config.test-columns")

-- Fix for number and sign columns
require("config.column-fix")

-- Function to detect Windows dark mode and update theme
local function update_theme_from_windows()
  local handle = io.popen("powershell.exe -Command \"(Get-ItemProperty -Path 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize').AppsUseLightTheme\" 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    -- Returns "0" for dark mode, "1" for light mode
    local is_dark = result:match("0") ~= nil
    local new_theme = is_dark and "astrodark" or "astrolight"
    
    -- Only change if different from current
    if vim.g.colors_name ~= new_theme then
      vim.cmd("colorscheme " .. new_theme)
    end
  end
end

-- Create user command to manually refresh theme
vim.api.nvim_create_user_command("RefreshTheme", update_theme_from_windows, {
  desc = "Refresh theme based on Windows system settings"
})

-- Optionally, auto-refresh theme on focus
vim.api.nvim_create_autocmd({ "FocusGained", "VimEnter" }, {
  callback = update_theme_from_windows,
  desc = "Update theme when Neovim gains focus"
})

-- Setup Claude Code theme synchronization
require("sync_claude_theme").setup_auto_sync()
