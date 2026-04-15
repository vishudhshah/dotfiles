return {
  -- smear-cursor for smooth cursor movement
  {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.7,
      matrix_pixel_threshold = 0.5,
      cursor_color = "#37b6ff",
    },
  },
}
