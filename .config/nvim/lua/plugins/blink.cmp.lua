return {
  -- Disable NvChad's built-in cmp
  { "hrsh7th/nvim-cmp",         enabled = false },
  { "L3MON4D3/LuaSnip",         enabled = false },
  { "saadparwaiz1/cmp_luasnip", enabled = false },
  { "hrsh7th/cmp-nvim-lua",     enabled = false },
  { "hrsh7th/cmp-nvim-lsp",     enabled = false },
  { "hrsh7th/cmp-buffer",       enabled = false },
  { "hrsh7th/cmp-path",         enabled = false },

  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },

    version = '1.*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) similar to built-in completions (C-y to accept)
      -- 'super-tab' similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 200 } },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}
