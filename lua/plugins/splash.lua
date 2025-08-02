-- Store splash state globally
_G.splash_timer = nil
_G.splash_window = nil
_G.splash_buffer = nil

-- ASCII art for AstroNvim
local splash_content = {
  "",
  "",
  "",
  "",
  "",
  "                                          █████████████████████████████████████████████████████████████████████████████████████████████   ",
  "                                          █▌                                                                                         ▐█   ",
  "                                          █▌                                                                                         ▐█   ",
  "                                          █▌                                                                                         ▐█   ",
  "                                          █▌      █████╗ ███████╗████████╗██████╗  ██████╗     ███╗   ██╗██╗   ██╗██╗███╗   ███╗     ▐█   ",
  "                                          █▌     ██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗    ████╗  ██║██║   ██║██║████╗ ████║     ▐█   ",
  "                                          █▌     ███████║███████╗   ██║   ██████╔╝██║   ██║    ██╔██╗ ██║██║   ██║██║██╔████╔██║     ▐█   ",
  "                                          █▌     ██╔══██║╚════██║   ██║   ██╔══██╗██║   ██║    ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║     ▐█   ",
  "                                          █▌     ██║  ██║███████║   ██║   ██║  ██║╚██████╔╝    ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║     ▐█   ",
  "                                          █▌     ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝     ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝     ▐█   ",
  "                                          █▌                                                                                         ▐█   ",
  "                                          █▌                                                                                         ▐█   ",
  "                                          █▌                                                                                         ▐█   ",
  "                                          █████████████████████████████████████████████████████████████████████████████████████████████   ",
  "",
}

local function create_splash_overlay()
  -- Only proceed if no files were opened
  if vim.fn.argc() ~= 0 then return end

  -- Delete any existing empty buffer immediately
  local current_buf = vim.api.nvim_get_current_buf()
  if vim.api.nvim_buf_is_valid(current_buf) then
    local name = vim.api.nvim_buf_get_name(current_buf)
    local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)
    if name == "" and #lines <= 1 and (lines[1] or "") == "" then
      -- Create splash buffer first to replace the empty buffer
      _G.splash_buffer = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(_G.splash_buffer, 0, -1, false, splash_content)
      vim.api.nvim_buf_set_option(_G.splash_buffer, "modifiable", false)
      vim.api.nvim_buf_set_option(_G.splash_buffer, "bufhidden", "wipe")

      -- Switch to splash buffer immediately
      vim.api.nvim_set_current_buf(_G.splash_buffer)

      -- Delete the empty buffer
      pcall(vim.api.nvim_buf_delete, current_buf, { force = true })
    else
      -- Create splash buffer normally
      _G.splash_buffer = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(_G.splash_buffer, 0, -1, false, splash_content)
      vim.api.nvim_buf_set_option(_G.splash_buffer, "modifiable", false)
      vim.api.nvim_buf_set_option(_G.splash_buffer, "bufhidden", "wipe")
    end
  else
    -- Create splash buffer normally
    _G.splash_buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(_G.splash_buffer, 0, -1, false, splash_content)
    vim.api.nvim_buf_set_option(_G.splash_buffer, "modifiable", false)
    vim.api.nvim_buf_set_option(_G.splash_buffer, "bufhidden", "wipe")
  end

  -- Get screen dimensions
  local width = vim.o.columns
  local height = vim.o.lines

  -- Create floating window that covers entire screen
  _G.splash_window = vim.api.nvim_open_win(_G.splash_buffer, true, {
    relative = "editor",
    row = 0,
    col = 0,
    width = width,
    height = height,
    style = "minimal",
    border = "none",
    zindex = 1000, -- High z-index to ensure it's on top
  })

  -- Create custom highlight group for splash text
  vim.api.nvim_set_hl(0, "SplashText", { fg = "#49c2b8" }) -- Teal color
  
  -- Set window options
  vim.api.nvim_win_set_option(_G.splash_window, "winhl", "Normal:SplashText")
  vim.api.nvim_win_set_option(_G.splash_window, "cursorline", false)
  vim.api.nvim_win_set_option(_G.splash_window, "cursorcolumn", false)

  -- Hide cursor during splash screen
  vim.opt.guicursor = "a:ver1-Cursor/lCursor"
  vim.cmd "hi Cursor blend=100"
  vim.cmd "hi lCursor blend=100"

  -- Center the content - set cursor to a valid position
  local cursor_row = math.min(#splash_content, math.max(1, math.floor(#splash_content / 2)))
  vim.api.nvim_win_set_cursor(_G.splash_window, { cursor_row, 0 })

  -- Start async timer to close splash screen after 1.5 seconds
  _G.splash_timer = vim.loop.new_timer()
  _G.splash_timer:start(
    1200,
    0,
    vim.schedule_wrap(function()
      -- Restore cursor visibility
      vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
      vim.cmd "hi Cursor blend=0"
      vim.cmd "hi lCursor blend=0"

      -- Close splash overlay
      if _G.splash_window and vim.api.nvim_win_is_valid(_G.splash_window) then
        pcall(vim.api.nvim_win_close, _G.splash_window, true)
        _G.splash_window = nil
      end
      if _G.splash_buffer and vim.api.nvim_buf_is_valid(_G.splash_buffer) then
        pcall(vim.api.nvim_buf_delete, _G.splash_buffer, { force = true })
        _G.splash_buffer = nil
      end

      -- Clean up timer
      if _G.splash_timer then
        _G.splash_timer:stop()
        _G.splash_timer:close()
        _G.splash_timer = nil
      end
    end)
  )
end

-- Create splash immediately on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Run splash creation immediately, not scheduled
    create_splash_overlay()
  end,
  desc = "Create 50ms splash overlay on startup",
})

-- Clean up on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if _G.splash_timer then
      _G.splash_timer:stop()
      _G.splash_timer:close()
      _G.splash_timer = nil
    end
    if _G.splash_window and vim.api.nvim_win_is_valid(_G.splash_window) then
      pcall(vim.api.nvim_win_close, _G.splash_window, true)
    end
  end,
})

return {}
