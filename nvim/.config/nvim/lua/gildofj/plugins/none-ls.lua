return {
  "nvimtools/none-ls.nvim", -- configure formatters & linters
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to enable uncomment this
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls-extras.nvim",
    "jay-babu/mason-null-ls.nvim",
  },
  config = function()
    local mason_null_ls = require("mason-null-ls")
    local null_ls = require("null-ls")
    local null_ls_utils = require("null-ls.utils")
    local null_ls_helpers = require("null-ls.helpers")

    mason_null_ls.setup({
      ensure_installed = {
        "stylua", -- lua formatter
        "prettierd", -- prettier formatter
        "eslint_d", -- js linter
        "ruff", -- python linter
      },
    })

    -- for conciseness
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    -- to setup format on save
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    -- Caminho do Ruff do virtualenv do Poetry
    local poetry_venv = vim.fn.system("poetry env info -p"):gsub("\n", "")
    local ruff_path = poetry_venv .. (Utils.is_win() and "\\Scripts\\ruff.exe" or "/bin/ruff")

    -- Ruff como DIAGNOSTIC
    local ruff_diagnostics = {
      method = null_ls.methods.DIAGNOSTICS,
      filetypes = { "python" },
      generator = null_ls.generator({
        command = ruff_path,
        args = { "check", "--quiet", "--stdin-filename", "$FILENAME", "-" },
        to_stdin = true,
        from_stderr = false,
        format = "line",
        check_exit_code = function(code)
          return code <= 1
        end,
        on_output = null_ls_helpers.diagnostics.from_pattern(
          [[^(.*?):(\d+):(\d+):\s([A-Z]\d+)\s(.*)]],
          { "file", "row", "col", "code", "message" },
          {
            severities = {
              ["E"] = null_ls_helpers.diagnostics.severities.error,
              ["F"] = null_ls_helpers.diagnostics.severities.error,
              ["W"] = null_ls_helpers.diagnostics.severities.warning,
            },
          }
        ),
      }),
    }

    -- Ruff como FORMATTER
    local ruff_formatter = {
      method = null_ls.methods.FORMATTING,
      filetypes = { "python" },
      generator = null_ls.formatter({
        command = ruff_path,
        args = { "format", "--stdin-filename", "$FILENAME", "-" },
        to_stdin = true,
      }),
    }

    -- configure null_ls
    null_ls.setup({
      -- add package.json as identifier for root (for typescript monorepos)
      root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
      -- setup formatters & linters
      sources = {
        formatting.stylua, -- lua formatter
        formatting.prettierd, -- js/ts formatter
        ruff_formatter, -- python formatting
        ruff_diagnostics, -- python diagnostics
        require("none-ls.diagnostics.eslint_d").with({ -- js/ts linter eslint
          condition = function(utils)
            return utils.root_has_file({
              ".eslintrc",
              ".eslintrc.js",
              ".eslintrc.cjs",
              ".eslintrc.json",
              "eslint.config.js",
              "eslint.config.mjs",
              "eslint.config.cjs",
            })
          end,
        }),
      },
      -- configure format on save
      on_attach = function(current_client, bufnr)
        if current_client:supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                filter = function(client)
                  --  only use null-ls for formatting instead of lsp server
                  return client.name == "null-ls"
                end,
                bufnr = bufnr,
              })
            end,
          })
        end
      end,
    })
  end,
}
