return {
  -- NvimTree: auto-resize to longest filename + better git icons + single click
  {
    "nvim-tree/nvim-tree.lua",
    config = function(_, opts)
      -- merge our overrides on top of whatever NvChad passes in
      opts = vim.tbl_deep_extend("force", opts or {}, {
        filters = {
          git_ignored = false,
        },
        view = {
          adaptive_size = true,  -- resize panel to fit the longest visible filename
          signcolumn = "no",     -- remove the left sign column (main source of left padding)
        },
        renderer = {
          icons = {
            padding = " ",       -- single space between icon and filename
            glyphs = {
              git = {
                untracked = "✗", -- red cross: "I don't know this file at all"
                unstaged  = "\u{f040}", -- fa-pencil: file is modified but not yet staged
              },
            },
          },
        },
        on_attach = function(bufnr)
          local api = require "nvim-tree.api"
          local function map(desc)
            return { desc = "nvim-tree: " .. desc, buf = bufnr, noremap = true, silent = true, nowait = true }
          end
          api.config.mappings.default_on_attach(bufnr)
          -- single left-click: send <LeftMouse> first so cursor moves to the
          -- clicked node, then immediately open/toggle it
          vim.keymap.set("n", "<LeftMouse>",
            "<LeftMouse><cmd>lua require('nvim-tree.api').node.open.edit()<cr>",
            map("Open"))
        end,
      })
      require("nvim-tree").setup(opts)
    end,
  },
}
