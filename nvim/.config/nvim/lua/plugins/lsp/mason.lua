return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettierd", -- js/ts formatter
        "stylua", -- lua formatter
        "rust-analyzer", -- rust formatter
        "isort", -- python formatter
        "black", -- python formatter
        "eslint_d", -- js/ts linter
        "pylint", -- python linter
      },
      auto_update = true,
    })
  end,
}
