return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",         -- search hidden files
        "--no-ignore-vcs",  -- ignore .gitignore
        "--glob=!**/.git/**",
        "--glob=!**/node_modules/**",
      },
    },
  },
}
