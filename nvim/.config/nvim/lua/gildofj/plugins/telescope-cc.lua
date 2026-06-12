return {
  "olacin/telescope-cc.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  keys = {
    {
      "<leader>gc",
      function()
        local actions = require("telescope._extensions.conventional_commits.actions")
        local picker = require("telescope._extensions.conventional_commits.picker")
        local themes = require("telescope.themes")

        local opts = {
          action = actions.prompt,
          include_body_and_footer = true,
        }
        opts = vim.tbl_extend("force", opts, themes["get_ivy"]())

        picker(opts)
      end,
      desc = "Git Conventional Commit",
    },
  },
  config = function()
    require("telescope").load_extension("conventional_commits")
  end,
}
