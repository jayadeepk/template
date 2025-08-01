-- Heirline statusline configuration
-- Custom statusline with clock component

---@type LazySpec
return {
  "rebelot/heirline.nvim",
  dependencies = { "AstroNvim/astroui", "AstroNvim/astrocore" },
  opts = function(_, opts)
    local status = require("astroui.status")
    local get_icon = require("astroui").get_icon

    -- Custom git branch component that always shows when in git repo
    local custom_git_branch = {
      condition = function()
        return vim.fn.isdirectory(".git") == 1 or vim.fn.finddir(".git", ".;") ~= ""
      end,
      provider = function()
        local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
        if branch and branch ~= "" then
          return get_icon("GitBranch", 1, true) .. branch .. " "
        end
        return ""
      end,
      hl = { fg = "#98be65", bold = true },
      update = { "BufEnter", "DirChanged", "FocusGained" },
    }

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
      custom_git_branch, -- Use custom git branch component
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