require "nvchad.options"

-- add yours here!

-- Highlight the current line
-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- Relative line numbers
vim.opt.relativenumber = true

-- Code folding
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "▼",
  foldsep = " ",
  foldclose = "▶",
}

-- Default indentation
vim.opt.tabstop = 2       -- width of a tab character
vim.opt.shiftwidth = 2    -- indent size for >> and autoindent
vim.opt.softtabstop = 2   -- spaces inserted when pressing tab
vim.opt.expandtab = true  -- use spaces instead of tabs

-- Per-filetype overrides
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "java", "c", "cpp", "html", "javascript", "tex", "json" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})
