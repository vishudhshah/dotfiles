-- todo-comments.nvim for highlighting and searching TODO comments
return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  opts = {
    highlight = {
      keyword = "bg",
      after = "",
    },
    colors = {
      info = { "#00cdfe" },  -- cadetblue, soft and muted
    },
  }
}
