-- Issues in LaTeX files
return {
  "olimorris/onedarkpro.nvim",
  enabled = false,
  event = "VeryLazy",
  config = function()
    require("onedarkpro").setup({
      options = { transparency = true },
      styles = {
        comments = "italic",
        parameters = "italic",
        functions = "bold",
        methods = "bold",
      },
      highlights = {
        CursorLineNr = { fg = "${line_number}", bold = true },
      },
    })
    vim.cmd.colorscheme "onedark_vivid"
  end,
}
