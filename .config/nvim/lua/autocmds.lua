require "nvchad.autocmds"

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.winhighlight = "Normal:TermNormal"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function() pcall(vim.treesitter.start) end,
})
