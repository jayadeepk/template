return {
  "lewis6991/gitsigns.nvim",
  opts = function(_, opts)
    -- Ensure on_attach is called to set up keymaps
    opts.on_attach = function(bufnr)
      local gitsigns = require "gitsigns"
      
      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      map("n", "]g", gitsigns.next_hunk, "Next Git hunk")
      map("n", "[g", gitsigns.prev_hunk, "Previous Git hunk")
      
      -- Actions
      map("n", "<Leader>gl", gitsigns.blame_line, "View Git blame")
      map("n", "<Leader>gL", function() gitsigns.blame_line { full = true } end, "View full Git blame")
      map("n", "<Leader>gp", gitsigns.preview_hunk_inline, "Preview Git hunk")
      map("n", "<Leader>gr", gitsigns.reset_hunk, "Reset Git hunk")
      map("n", "<Leader>gR", gitsigns.reset_buffer, "Reset Git buffer")
      map("n", "<Leader>gs", gitsigns.stage_hunk, "Stage Git hunk")
      map("n", "<Leader>gS", gitsigns.stage_buffer, "Stage Git buffer")
      map("n", "<Leader>gu", gitsigns.undo_stage_hunk, "Unstage Git hunk")
      
      -- Git diff functionality
      map("n", "<Leader>gd", function()
        gitsigns.diffthis()
      end, "View Git diff")
      
      -- Alternative diff commands
      map("n", "<Leader>gD", function()
        gitsigns.diffthis("~1")
      end, "View Git diff with last commit")
      
      -- Function-aware diff (shows minimal context)
      map("n", "<Leader>gf", function()
        -- Set reduced context and open diff
        vim.opt.diffopt = "internal,filler,closeoff,hiddenoff,foldcolumn:0,context:3,algorithm:patience,iwhite"
        gitsigns.diffthis()
        -- Force diff update to apply new options
        vim.cmd("diffupdate")
      end, "View Git diff with minimal context")
      
      -- Full context diff 
      map("n", "<Leader>gF", function()
        -- Set full context and open diff
        vim.opt.diffopt = "internal,filler,closeoff,hiddenoff,foldcolumn:0,context:99999,algorithm:patience,iwhite,linematch:60"
        gitsigns.diffthis()
        -- Force diff update to apply new options
        vim.cmd("diffupdate")
      end, "View Git diff with full context")
    end
    
    return opts
  end,
}