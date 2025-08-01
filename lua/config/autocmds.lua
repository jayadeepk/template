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