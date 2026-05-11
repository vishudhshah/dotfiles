return {
  "nvim-mini/mini.animate",
  version = false,
  event = "VeryLazy",
  opts = function()
    local animate = require("mini.animate")
    return {
      cursor = {
        enable = false,
        timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
      },
      scroll = {
        enable = true,
        timing = animate.gen_timing.quadratic({ duration = 150, unit = "total" }),
      },
      resize = { enable = false },
      open = { enable = false },
      close = { enable = false },
    }
  end,
}
