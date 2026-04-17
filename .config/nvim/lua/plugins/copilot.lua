-- GitHub Copilot inline suggestions
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept      = "<C-l>",  -- accept full suggestion
        accept_word = "<C-k>",  -- accept next word (no macOS conflict)
        accept_line = false,
        next        = "<M-]>",  -- Option+] to cycle next
        prev        = "<M-[>",  -- Option+[ to cycle prev
        dismiss     = "<C-e>",  -- dismiss
      },
    },
    panel = { enabled = false },  -- ghost text only, no panel
    filetypes = {
      ["."] = true,  -- enable for all filetypes
      sh = function()
        -- disable for .env files
        if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
          return false
        end
        return true
      end,
    },
  },
}
