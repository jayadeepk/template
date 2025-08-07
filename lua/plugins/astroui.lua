-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

-- Function to detect Windows dark mode from WSL
local function is_windows_dark_mode()
  local handle = io.popen("powershell.exe -Command \"(Get-ItemProperty -Path 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize').AppsUseLightTheme\" 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    -- Returns "0" for dark mode, "1" for light mode
    return result:match("0") ~= nil
  end
  -- Default to dark mode if detection fails
  return true
end

-- Determine colorscheme based on Windows theme
local colorscheme = is_windows_dark_mode() and "astrodark" or "astrolight"

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- change colorscheme
    colorscheme = colorscheme,
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      init = { -- this table overrides highlights in all themes
        -- Normal = { bg = "#000000" },
      },
      astrodark = { -- a table of overrides/changes when applying the astrotheme theme
        -- Normal = { bg = "#000000" },
        -- Ensure dark theme tabline uses dark colors
        TabLine = { bg = "#1e222a", fg = "#abb2bf" },
        TabLineFill = { bg = "#1e222a" },
        TabLineSel = { bg = "#282c34", fg = "#abb2bf", bold = true },
      },
      astrolight = { -- overrides for the light theme
        -- Force terminal to use white background in light mode
        Terminal = { bg = "#FFFFFF", fg = "#000000" },
        TerminalNormal = { bg = "#FFFFFF", fg = "#000000" },
        TerminalNC = { bg = "#FFFFFF", fg = "#000000" },
        -- Force tabline/bufferline to use white background
        TabLine = { bg = "#FFFFFF", fg = "#000000" },
        TabLineFill = { bg = "#FFFFFF" },
        TabLineSel = { bg = "#FFFFFF", fg = "#000000", bold = true },
        BufferLine = { bg = "#FFFFFF" },
        BufferLineFill = { bg = "#FFFFFF" },
        BufferLineTab = { bg = "#FFFFFF", fg = "#000000" },
        BufferLineTabSelected = { bg = "#FFFFFF", fg = "#000000", bold = true },
        BufferLineBackground = { bg = "#FFFFFF" },
        BufferLineBufferSelected = { bg = "#FFFFFF", fg = "#000000", bold = true },
        BufferLineBufferVisible = { bg = "#FFFFFF", fg = "#000000" },
        -- Heirline specific highlights
        HeirlineNormal = { bg = "#FFFFFF" },
        HeirlineInsert = { bg = "#FFFFFF" },
        HeirlineVisual = { bg = "#FFFFFF" },
        HeirlineReplace = { bg = "#FFFFFF" },
        HeirlineCommand = { bg = "#FFFFFF" },
        HeirlineInactive = { bg = "#FFFFFF" },
      },
    },
    -- Icons can be configured throughout the interface
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
