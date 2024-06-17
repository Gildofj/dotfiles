return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("harpoon").setup({
      tabline = true,
    })

    -- keymaps
    vim.keymap.set(
      "n",
      "<leader>hm",
      "<cmd>lua require('harpoon.mark').add_file()<cr>",
      { desc = "Mark file with harpoon" }
    )
    vim.keymap.set(
      "n",
      "<leader>hp",
      "<cmd>lua require('harpoon.ui').nav_prev()<cr>",
      { desc = "Go to previous harpoon mark" }
    )
    vim.keymap.set(
      "n",
      "<leader>hn",
      "<cmd>lua require('harpoon.ui').nav_next()<cr>",
      { desc = "Go to next harpoon mark" }
    )
    vim.keymap.set("n", "<leader>ha", "<cmd>Telescope harpoon marks<cr>", { desc = "Show harpoon marks in telescope" })
    vim.keymap.set(
      "n",
      "<leader>hl",
      "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
      { desc = "Show harpoon marks" }
    )
    vim.keymap.set("n", "<leader>h1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", { desc = "Nav to file 1" })
    vim.keymap.set("n", "<leader>h2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", { desc = "Nav to file 2" })
    vim.keymap.set("n", "<leader>h3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", { desc = "Nav to file 3" })
    vim.keymap.set("n", "<leader>h4", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", { desc = "Nav to file 4" })
  end,
}
