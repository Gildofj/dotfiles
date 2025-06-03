return {
  "echasnovski/mini.animate",
  version = "*",
  event = "VeryLazy",
  cond = vim.g.neovide == nil,
  config = function()
    local animate = require("mini.animate")

    animate.setup({
      cursor = {
        enable = true,
        timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        path = animate.gen_path.line(),
      },
      scroll = {
        enable = true,
        timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
      },
      open = {
        enable = true,
        timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
      },
      close = {
        enable = true,
        timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
      },
      resize = {
        enable = true,
        timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
      },
    })
  end,
}
