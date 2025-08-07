-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        laststatus = 3, -- global statusline
        -- Window management for 3-column layout
        winminwidth = 10, -- absolute minimum window width  
        equalalways = false, -- don't auto-equalize window sizes
        splitright = true, -- split windows to the right
        splitbelow = true, -- split windows below
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["gt"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["gT"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
        
        -- 3-column layout management
        ["<Leader>wn"] = { 
          function() 
            -- Set current window to 15% width (Neo-tree size)
            local total_width = vim.o.columns
            local target_width = math.floor(total_width * 0.15)
            vim.cmd("vertical resize " .. target_width)
          end, 
          desc = "Set window to 15% width (Neo-tree)" 
        },
        ["<Leader>wc"] = { 
          function() 
            -- Set current window to 35% width (Claude size)
            local total_width = vim.o.columns
            local target_width = math.floor(total_width * 0.35)
            vim.cmd("vertical resize " .. target_width)
          end, 
          desc = "Set window to 35% width (Claude)" 
        },
        ["<Leader>wr"] = { 
          function()
            -- Reset all windows to proper proportions
            local total_width = vim.o.columns
            local neotree_width = math.floor(total_width * 0.15)
            local claude_width = math.floor(total_width * 0.35)
            
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local bufname = vim.api.nvim_buf_get_name(buf)
              local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
              
              if ft == "neo-tree" then
                vim.api.nvim_win_set_width(win, neotree_width)
              elseif bufname:match("claude") then
                vim.api.nvim_win_set_width(win, claude_width)
              end
            end
          end, 
          desc = "Reset windows to proper proportions (15%-50%-35%)" 
        },
      },
    },
    -- Configure autocommands
    autocmds = {
      -- Auto-open Neo-tree file explorer on startup - DISABLED
      -- auto_neotree = {
      --   {
      --     event = "VimEnter",
      --     callback = function()
      --       -- Only open Neo-tree if no files were opened and we're not in a directory
      --       if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
      --         vim.defer_fn(function()
      --           vim.cmd("Neotree show")
      --         end, 10)
      --       end
      --     end,
      --     desc = "Auto-open Neo-tree on startup when no files specified",
      --   },
      -- },
      -- Ensure global statusline is always visible
      global_statusline = {
        {
          event = { "VimEnter", "WinEnter", "BufEnter" },
          callback = function()
            vim.opt.laststatus = 3
          end,
          desc = "Ensure global statusline is always visible",
        },
      },
    },
  },
}
