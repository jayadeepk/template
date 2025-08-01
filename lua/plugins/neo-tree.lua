---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    source_selector = {
      winbar = true,
      statusline = false,
      sources = {
        { source = "git_status", display_name = " 󰊢 Git " },
        { source = "filesystem", display_name = " 󰉓 File " },
        { source = "buffers", display_name = " 󰈚 Bufs " },
      },
    },
    -- Set git_status as the default source
    default_source = "git_status",
    filesystem = {
      use_libuv_file_watcher = true,
    },
    git_status = {
      use_libuv_file_watcher = true,  -- Enable file watcher for git_status source
    },
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function()
          -- Auto-refresh git status when entering neo-tree
          vim.defer_fn(function()
            local events = require("neo-tree.events")
            events.fire_event(events.GIT_EVENT)
          end, 100)
        end,
      },
    },
  },
}
