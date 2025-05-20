return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "cssmodules_ls",
          "emmet_ls",
          "html",
          "jsonls",
          "tailwindcss",
          "astro",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettierd", -- prettier formatter
          "stylua", -- lua formatter
          "eslint_d", -- js/ts linter
          "rust-analyzer", -- rust formatter
          "isort", -- python formatter
          "black", -- python formatter
          "pylint", -- python linter
        },
        auto_update = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
      "simrat39/rust-tools.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")

      local opts = { noremap = true, silent = true }

      local goto_next_diagnostic = function()
        vim.diagnostic.jump({ count = 1 })
      end

      local goto_prev_diagnostic = function()
        vim.diagnostic.jump({ count = -1 })
      end

      local on_attach = function(client, bufnr)
        opts.buffer = bufnr

        -- set keybinds
        opts.desc = "Show LSP references"
        vim.keymap.set("n", "gR", ":Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        vim.keymap.set("n", "gi", ":Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        vim.keymap.set("n", "gt", ":Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        vim.keymap.set({ "n", "v" }, "<leader>r", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        vim.keymap.set("n", "<leader>D", ":Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        vim.keymap.set("n", "[d", goto_prev_diagnostic, opts)

        opts.desc = "Go to next diagnostic"
        vim.keymap.set("n", "]d", goto_next_diagnostic, opts)

        opts.desc = "Show documentation for what is under cursor"
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end

      -- Change the Diagnostic symbols in the sign column (gutter)
      -- (not in youtube nvim video)
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local util = require("lspconfig/util")

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            -- make the language server recognize "vim" global
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              -- make language server aware of runtime files
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      })

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.cssmodules_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.emmet_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = {
          "html",
          "typescriptreact",
          "javascriptreact",
          "css",
          "sass",
          "scss",
          "less",
        },
      })

      lspconfig.html.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.jsonls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.jdtls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.kotlin_language_server.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "rust" },
        root_dir = util.root_pattern("Cargo.toml"),
        settings = {
          ["rust_analyzer"] = {
            cargo = {
              allFeatures = true,
            },
          },
        },
      })
      require("rust-tools").setup({
        server = {},
      })

      lspconfig.astro.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "astro" },
      })

      lspconfig.csharp_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "csharp" },
      })
    end,
  },
}
