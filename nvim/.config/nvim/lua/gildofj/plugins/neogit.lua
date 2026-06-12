return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>gg", function() require("neogit").open() end, desc = "Neogit Status" },
  },
  opts = {
    disable_commit_confirmation = true,
    integrations = {
      diffview = true,
      telescope = true,
    },
  },
}
