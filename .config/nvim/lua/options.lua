require "nvchad.options"

-- add yours here!

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
