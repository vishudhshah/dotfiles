return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- Treesitter with extra languages
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function()
      require("nvim-treesitter").install({
        "vim", "lua", "vimdoc",
        "html", "css",
        "c", "cpp", "python", "javascript", "java", "latex"
      })
    end,
  },

  -- Added by VS

  -- NvimTree: auto-resize to longest filename + better git icons + single click
  {
    "nvim-tree/nvim-tree.lua",
    config = function(_, opts)
      -- merge our overrides on top of whatever NvChad passes in
      opts = vim.tbl_deep_extend("force", opts or {}, {
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

  -- mini.icons: modern, broader icon coverage (drop-in for nvim-web-devicons)
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- GitHub Copilot inline suggestions
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept      = "<C-l>",  -- accept full suggestion
          accept_word = "<C-k>",  -- accept next word (no macOS conflict)
          accept_line = false,
          next        = "<M-]>",  -- Option+] to cycle next
          prev        = "<M-[>",  -- Option+[ to cycle prev
          dismiss     = "<C-e>",  -- dismiss
        },
      },
      panel = { enabled = false },  -- ghost text only, no panel
      filetypes = {
        ["."] = true,  -- enable for all filetypes
        sh = function()
          -- disable for .env files
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
            return false
          end
          return true
        end,
      },
    },
  },

  -- ToggleTerm
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {},
  },

  -- smear-cursor for smooth cursor movement
  {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.7,
      matrix_pixel_threshold = 0.5,
      cursor_color = "#37b6ff",
    },
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    opts = {
      mappings = {
        '<C-u>', '<C-d>',
        '<C-b>', '<C-f>',
        '<C-y>', '<C-e>',
        'zt', 'zz', 'zb',
      },
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
      easing = "sine",  -- "linear" | "sine" | "circular" | "quadratic" | "cubic" | "quartic" | "quintic" | "exponential"
      duration_multiplier = 1.0,  -- 0.8 makes it 20% faster
      performance_mode = false,
    },
  },

  -- nvim-ufo for code folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ufo").setup({
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
      })

      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)

      vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end)
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local builtin = require("statuscol.builtin")

      -- Custom fold indicator: arrow only, no depth digits
      local function fold_indicator()
        local lnum = vim.v.lnum
        local closed = vim.fn.foldclosed(lnum)
        local foldlevel = vim.fn.foldlevel(lnum)
        local prev_foldlevel = vim.fn.foldlevel(lnum - 1)

        if foldlevel == 0 then
          return " "  -- not foldable, blank
        end

        if closed == lnum then
          return "▶"  -- fold starts here and is closed
        end

        if foldlevel > prev_foldlevel then
          return "▼"  -- fold starts here and is open
        end

        return " "  -- inside a fold, blank
      end

      require("statuscol").setup({
        -- don't apply custom statuscolumn to these special windows
        ft_ignore = { "NvimTree", "lazy", "mason", "help", "toggleterm", "TelescopePrompt" },
        relculright = true,
        segments = {
          { text = { fold_indicator }, click = "v:lua.ScFa" },
          { text = { " " } },  -- spacer
          { text = { "%s" }, click = "v:lua.ScSa" },
          { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
        },
      })
    end,
  },

  -- render-markdown.nvim for markdown rendering in Neovim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    ft = { "markdown" },
    opts = {},
  },

  -- todo-comments.nvim for highlighting and searching TODO comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    opts = {
      highlight = {
        keyword = "bg",
        after = "",
      },
      colors = {
        info = { "#00cdfe" },  -- cadetblue, soft and muted
      },
    }
  }
}
