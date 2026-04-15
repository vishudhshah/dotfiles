return {
  -- Treesitter with extra languages
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function()
      require("nvim-treesitter").install({
        "vim", "lua", "vimdoc",
        "html", "css",
        "c", "cpp", "python", "javascript", "java", "latex"
      })
    end,
  },
}
