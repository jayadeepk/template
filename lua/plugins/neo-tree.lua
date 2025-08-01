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
  },
}