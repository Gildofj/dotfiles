return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  event = { "BufReadPre", "BufNewFile" },
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
        "prettierd", -- JS/TS formatter
        "stylua", -- Lua formatter
        "rust-analyzer", -- Rust LSP
        "eslint_d", -- JS/TS linter
        "ruff", -- Python linter & formatter
        "pyright", -- Python LSP
      },
      auto_update = false, -- Manually run :MasonToolsUpdate to save resources on startup
      run_on_start = true,
      start_delay = 3000, -- Delay installation checks by 3 seconds to prioritize UI responsiveness
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
