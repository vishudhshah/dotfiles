require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Cheat sheet (F1)
vim.keymap.set("n", "<F1>", function()
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = os.getenv("HOME") .. "/.config/cheat/cheat.sh",
    direction = "float",
    float_opts = { border = "rounded" },
    close_on_exit = true,
  })
  term:toggle()
end, { desc = "Cheat sheet" })
