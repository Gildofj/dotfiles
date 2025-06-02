return {
  "kiddos/gemini.nvim",
  build = { "pip install -r requirements.txt", ":UpdateRemotePlugins" },
  dependencies = "nvim-lualine/lualine.nvim",
  opts = {},
}
