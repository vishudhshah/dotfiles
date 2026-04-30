-- statusline config (currently not used)

local colors = {
  blue    = "#37b6ff",
  green   = "#5cf19e",
  purple  = "#ff57fd",
  yellow  = "#fed032",
  red     = "#fc3841",
  fg      = "#e7ebed",
  bg      = "#1a2434",
  mid     = "#435b67",
  muted   = "#a1b0b8",
  dark    = "#293339",
}

local function mode_theme(accent)
  return {
    a = { bg = accent, fg = colors.dark, gui = "bold" },
    b = { bg = colors.mid, fg = accent },
    c = { bg = colors.dark, fg = colors.fg },
  }
end

return {
  {
    'nvim-lualine/lualine.nvim',
    enabled = false,
    event = "VimEnter",  -- load on startup
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        globalstatus = true,
        theme = {
          normal   = mode_theme(colors.blue),
          insert   = mode_theme(colors.green),
          visual   = mode_theme(colors.purple),
          command  = mode_theme(colors.yellow),
          replace  = mode_theme(colors.red),
        },
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'lsp_status', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
    },
  },
}
