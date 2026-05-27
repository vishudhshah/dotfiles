-- LaTeX
return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk_engines = { _ = "-lualatex" }
    vim.g.vimtex_compiler_latexmk = {
      aux_dir = "",       -- same dir as source (can be changed to ".aux")
      out_dir = "",       -- same dir as source (can be changed to ".out")
      callback = 1,
      continuous = 1,     -- recompile on save, replaces -pvc
      executable = "latexmk",
      options = {
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
        "-shell-escape",  -- required by some packages (eg. minted)
      },
    }
    -- Conceal settings
    -- a - accents, b - bold/italic, d - delimiters (eg. \left[),
    -- m - math symbols, g - Greek letters
    vim.g.tex_conceal = "abdmg"
    -- Suppress warnings window
    vim.g.vimtex_quickfix_mode = 0
    -- Disable insert-mode mappings (handled by snippets)
    vim.g.vimtex_imaps_enabled = 0
  end
}
