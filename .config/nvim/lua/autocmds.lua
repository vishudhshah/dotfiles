require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- Transparent lazygit window in Neovim
autocmd("TermOpen", {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if not bufname:match("lazygit") then
      vim.opt_local.winhighlight = "Normal:TermNormal"
    end
  end
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
