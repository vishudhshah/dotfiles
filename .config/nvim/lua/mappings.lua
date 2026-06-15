require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")


-- Toggle focus between NvimTree and the file buffer
-- map("n", "<C-b>", function()
--   local api = require "nvim-tree.api"
--   if vim.bo.filetype == "NvimTree" then
--     vim.cmd "wincmd p"   -- jump to the previous (file) window
--   else
--     api.tree.focus()     -- open tree if closed, then focus it
--   end
-- end, { desc = "Toggle focus: NvimTree ↔ file" })


-- Cheat sheet (F1)
map("n", "<F1>", function()
  local term = require("toggleterm.terminal").Terminal:new({
    cmd = os.getenv("HOME") .. "/.config/cheat/cheat.sh",
    direction = "float",
    float_opts = { border = "rounded" },
    close_on_exit = true,
  })
  term:toggle()
end, { desc = "Cheat sheet" })


-- snacks.nvim keymaps
map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
map("n", "<leader>gl", function() Snacks.lazygit.log() end, { desc = "Lazygit log" })
map("n", "<leader>gf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit file log" })
pcall(vim.keymap.del, "n", "<leader>ds")
map("n", "<leader>d", function() Snacks.dashboard.open() end, { desc = "Dashboard" })

-- Suppress default space key behavior in normal and visual modes
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Shortcut to open snippets for current fileltype
map("n", "<leader>fs", function()
  local ft = vim.bo.filetype
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/snippets/" .. ft .. ".lua")
end, { desc = "Edit snippets for current filetype" })
