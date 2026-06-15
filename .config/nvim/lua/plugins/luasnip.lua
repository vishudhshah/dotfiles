-- LuaSnip: snippet engine
return {
  "L3MON4D3/LuaSnip",
  enabled = true, -- override blink.cmp.lua's disable
  version = "v2.*",
  build = "make install_jsregexp", -- enables regex triggers
  event = "InsertEnter",
  config = function()
    local ls = require("luasnip")

    ls.setup({
      enable_autosnippets = true,
      store_selection_keys = "<Tab>",
      history = true,
      update_events = "TextChanged,TextChangedI",
    })

    -- Load snippets from ~/.config/nvim/snippets/
    require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/snippets" })

    -- Jump forward / expand snippet
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      if ls.expand_or_jumpable() then ls.expand_or_jump() end
    end, { silent = true })

    -- Jump backward through tab stops
    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      if ls.jumpable(-1) then ls.jump(-1) end
    end, { silent = true })

    -- Cycle through choice nodes
    vim.keymap.set({ "i", "s" }, "<C-e>", function()
      if ls.choice_active() then ls.change_choice(1) end
    end, { silent = true })
  end,
}
