-- nvim-ufo for code folding
return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("ufo").setup({
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    })

    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
    vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)

    vim.keymap.set("n", "K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end)
  end,
}
