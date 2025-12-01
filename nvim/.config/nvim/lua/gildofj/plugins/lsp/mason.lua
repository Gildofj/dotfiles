return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    {
      "mrcjkb/rustaceanvim",
      version = "^6", -- Recommended
      lazy = false, -- This plugin is already lazy
    },
  },
  config = function()
    local mason = require("mason")
    local mason_tool_installer = require("mason-tool-installer")
    local mason_lsp_config = require("mason-lspconfig")
    local server_setup = require("gildofj.plugins.lsp.config.server_setup")

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

    mason_lsp_config.setup({
      ensure_installed = require("gildofj.plugins.lsp.config.ensure_installed_servers"),
    })

    server_setup.run()

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
  end,
}
