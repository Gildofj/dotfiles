return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
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
        "eslint_d", -- js/ts linter
        "ruff", -- python linter
        "pyright", -- python formatter
      },
      auto_update = true,
    })
  end,
}
