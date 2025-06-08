-- treatment for transparent background themes
local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
local background_hex = normal_hl.bg and string.format("#%06x", normal_hl.bg) or "#000000"

return {
  "rcarriga/nvim-notify",
  opts = {
    timeout = 10000,
    background_colour = background_hex,
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end,
}
