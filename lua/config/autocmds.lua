-- Auto-refresh Neo-tree git status on external changes
local augroup = vim.api.nvim_create_augroup("NeoTreeGitRefresh", { clear = true })

-- Refresh when focus returns to Neovim (after using external terminal)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = augroup,
  callback = function()
    -- Only refresh if Neo-tree is open
    local manager = require("neo-tree.sources.manager")
    local state = manager.get_state("git_status")
    if state and state.tree and state.tree.visible then
      vim.defer_fn(function()
        local events = require("neo-tree.events")
        events.fire_event(events.GIT_EVENT)
      end, 200)
    end
  end,
})

-- Refresh after terminal operations (if using :terminal)
vim.api.nvim_create_autocmd("TermClose", {
  group = augroup,
  callback = function()
    vim.defer_fn(function()
      local events = require("neo-tree.events")
      events.fire_event(events.GIT_EVENT)
    end, 500)
  end,
})