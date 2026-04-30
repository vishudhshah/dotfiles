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
