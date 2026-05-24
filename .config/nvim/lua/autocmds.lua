require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

autocmd("TermOpen", {
  callback = function()
    vim.opt_local.winhighlight = "Normal:TermNormal"
  end,
})

-- Conceal in TeX files
autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.opt_local.conceallevel = 2
    pcall(vim.treesitter.stop)  -- let VimTeX own syntax, not Treesitter
  end,
})

-- Change underline style to squiggle
autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.cmd("highlight DiagnosticUnderlineError gui=undercurl")
    vim.cmd("highlight DiagnosticUnderlineWarn gui=undercurl")
    vim.cmd("highlight DiagnosticUnderlineInfo gui=undercurl")
    vim.cmd("highlight DiagnosticUnderlineHint gui=undercurl")
  end,
})
