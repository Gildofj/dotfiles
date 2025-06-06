return {
  "smjonas/inc-rename.nvim",
  opts = function()
    vim.keymap.set("n", "<leader>ir", ":IncRename ")
    return {}
  end,
}
