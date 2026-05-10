-- smooth scrolling (replaced by mini.animate)
return {
  "karb94/neoscroll.nvim",
  enabled = false,
  event = "WinScrolled",
  opts = {
    mappings = {
      '<C-u>', '<C-d>',
      '<C-b>', '<C-f>',
      '<C-y>', '<C-e>',
      'zt', 'zz', 'zb',
    },
    hide_cursor = true,
    stop_eof = true,
    respect_scrolloff = false,
    cursor_scrolls_alone = true,
    easing = "sine",  -- "linear" | "sine" | "circular" | "quadratic" | "cubic" | "quartic" | "quintic" | "exponential"
    duration_multiplier = 1.0,  -- 0.8 makes it 20% faster
    performance_mode = false,
  },
}
