return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = true,
  keys = {
    -- stylua: ignore
    { "<leader>sr", function() require("spectre").open() end, desc = "Search & Replace (Spectre)" },
  },
}
