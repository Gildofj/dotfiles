return {
  "rcarriga/nvim-notify",
  opts = {
    timeout = 10000,
  },
  config = function()
    vim.notify = require("notify")
  end,
}
