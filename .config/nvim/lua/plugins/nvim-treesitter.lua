return {
  -- Treesitter with extra languages
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require("nvim-treesitter").install({
        "vim", "lua", "vimdoc",
        "html", "css", "javascript",
        "c", "cpp", "python",
        "java", "latex"
      })
    end,
  },
}
