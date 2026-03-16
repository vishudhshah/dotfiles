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
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
        "html", "css",
        "c", "cpp", "python", "javascript", "java", "latex"
  		},
  	},
  },

  -- Added by VS

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

  -- Neovim command line suggestions
  {
    "gelguy/wilder.nvim",
    event = "CmdlineEnter",
    config = function()
      local wilder = require("wilder")
      wilder.setup({ modes = { ":", "/", "?" } })

      wilder.set_option("renderer", wilder.popupmenu_renderer(
        wilder.popupmenu_border_theme({
          border = "rounded",
          highlights = { border = "Normal" },
          pumblend = 20,
          left  = { " ", wilder.popupmenu_devicons() },
          right = { " ", wilder.popupmenu_scrollbar() },
        })
      ))

      wilder.set_option("pipeline", {
        wilder.branch(
          wilder.cmdline_pipeline({ fuzzy = 1 }),
          wilder.search_pipeline()
        ),
      })
    end,
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
}
