-- Auto-refresh Neo-tree git status on .git folder changes
local augroup = vim.api.nvim_create_augroup("NeoTreeGitRefresh", { clear = true })

-- Watch .git folder for changes (staging, commits, etc.)
local git_watcher = nil

local function refresh_neo_tree()
  -- Fire git event to refresh Neo-tree git status
  local events_ok, neo_events = pcall(require, "neo-tree.events")
  if events_ok then
    neo_events.fire_event(neo_events.GIT_EVENT)
  end
end

local function start_git_watcher()
  local git_dir = vim.fn.finddir('.git', '.;')
  if git_dir == '' then
    print("No .git directory found")
    return
  end
  
  local git_path = vim.fn.fnamemodify(git_dir, ':p')
  print("Starting git watcher for: " .. git_path)
  
  -- Stop existing watcher if it exists
  if git_watcher then
    git_watcher:stop()
    git_watcher = nil
  end
  
  git_watcher = vim.loop.new_fs_event()
  local success = git_watcher:start(git_path, { recursive = true }, function(err, filename, events)
    if err then
      print("Git watcher error: " .. err)
      return
    end
    
    print("Git file changed: " .. (filename or "unknown"))
    
    -- Only refresh on relevant git changes
    if filename and (
      filename:match("index") or            -- Staging changes (including index.lock)
      filename:match("logs/HEAD") or        -- Commits (including HEAD.lock)
      filename:match("refs/heads/") or      -- Branch changes
      filename:match("MERGE_HEAD") or       -- Merge operations
      filename:match("COMMIT_EDITMSG") or   -- Commits in progress
      filename:match("HEAD") or             -- HEAD changes
      filename:match("ORIG_HEAD")           -- Reset/rebase operations
    ) then
      print("Relevant git change detected, refreshing Neo-tree")
      vim.schedule(refresh_neo_tree)
    end
  end)
  
  if not success then
    print("Failed to start git watcher")
  else
    print("Git watcher started successfully")
  end
end

-- Start git watcher on VimEnter if in a git repo
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  callback = function()
    vim.defer_fn(start_git_watcher, 500)
  end,
})

-- Clean up watcher on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = augroup,
  callback = function()
    if git_watcher then
      git_watcher:stop()
      git_watcher = nil
    end
  end,
})

-- Window management for 3-column layout
local window_group = vim.api.nvim_create_augroup("WindowManagement", { clear = true })

-- Function to enforce specific widths for different windows
local function enforce_window_widths()
  local total_width = vim.o.columns
  local neotree_width = math.floor(total_width * 0.15)  -- 15%
  local claude_width = math.floor(total_width * 0.35)   -- 35%
  
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)
    local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    
    -- Enforce 15% width for Neo-tree
    if ft == "neo-tree" then
      vim.api.nvim_win_set_width(win, neotree_width)
      vim.api.nvim_win_set_option(win, 'winfixwidth', true)
    end
    
    -- Enforce 35% width for Claude terminal
    if bufname:match("claude") then
      vim.api.nvim_win_set_width(win, claude_width)
      vim.api.nvim_win_set_option(win, 'winfixwidth', true)
    end
  end
end

-- Maintain window proportions on various events
vim.api.nvim_create_autocmd({"WinResized", "VimResized", "WinClosed", "BufWinLeave"}, {
  group = window_group,
  callback = function()
    vim.defer_fn(enforce_window_widths, 100)
  end,
  desc = "Maintain 30% window widths",
})

-- Set window options for consistent layout
vim.api.nvim_create_autocmd({"WinEnter", "BufWinEnter"}, {
  group = window_group,
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    local bufname = vim.api.nvim_buf_get_name(buf)
    
    -- Set fixed width for Neo-tree and Claude windows
    if ft == "neo-tree" or bufname:match("claude") then
      vim.wo.winfixwidth = true
      vim.defer_fn(enforce_window_widths, 50)
    end
  end,
  desc = "Set window options for fixed layout",
})