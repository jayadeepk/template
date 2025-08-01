-- Heirline statusline configuration
-- Custom statusline with clock component

---@type LazySpec
return {
  "rebelot/heirline.nvim",
  dependencies = { "AstroNvim/astroui", "AstroNvim/astrocore" },
  opts = function(_, opts)
    local status = require("astroui.status")
    local get_icon = require("astroui").get_icon

    -- Clock component
    local clock = {
      provider = function()
        return os.date(" %H:%M ")
      end,
      hl = { fg = "#ffffff", bg = "#3f4b56", bold = true },
      update = 1000, -- Update every second
    }

    -- Define the statusline
    opts.statusline = {
      hl = { fg = "fg", bg = "bg" },
      status.component.mode { surround = { separator = "left", color = "mode_bg" } },
      status.component.git_branch(),
      status.component.file_info(),
      status.component.git_diff(),
      status.component.diagnostics(),
      status.component.fill(),
      status.component.cmd_info(),
      status.component.fill(),
      status.component.lsp(),
      clock, -- Add clock component
      status.component.virtual_env(),
      status.component.treesitter(),
      status.component.nav(),
      status.component.mode { surround = { separator = "right", color = "mode_bg" } },
    }

    return opts
  end,
}