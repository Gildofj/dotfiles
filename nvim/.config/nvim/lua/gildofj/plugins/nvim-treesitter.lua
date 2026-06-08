return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Forçamos a master para estabilidade a longo prazo
    branch = "master", 
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash", "c", "diff", "html", "javascript", "jsdoc", "json", "jsonc", "lua", "luadoc", "luap",
        "markdown", "markdown_inline", "python", "query", "regex", "toml", "tsx", "typescript", "vim",
        "vimdoc", "yaml", "rust", "astro", "css", "scss", "sql"
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
          },
        },
      },
    },
    config = function(_, opts)
      -- Lógica Cross-Platform para Compiladores
      local install = require("nvim-treesitter.install")
      install.prefer_git = true -- Força o uso do Git para evitar erros com 'tar' e downloads corrompidos
      if vim.fn.has("win32") == 1 then
        install.compilers = { "cl", "gcc", "clang" }
      elseif vim.fn.has("mac") == 1 then
        install.compilers = { "clang", "cc", "gcc" }
        -- Fix crítico para Mac: Garante que o compilador ache o stdlib.h e headers do sistema
        local sdk_path = vim.fn.trim(vim.fn.system("xcrun --show-sdk-path"))
        if sdk_path ~= "" then
          vim.env.SDKROOT = sdk_path
        end
      else
        install.compilers = { "gcc", "clang", "cc" }
      end

      -- Tenta carregar o modo clássico (master/antigo)
      local status, configs = pcall(require, "nvim-treesitter.configs")
      if status then
        configs.setup(opts)
      else
        -- Fallback para o modo novo (main/experimental)
        local ts_status, ts = pcall(require, "nvim-treesitter")
        if ts_status and ts.setup then
           ts.setup(opts)
        end
      end

      -- Mapeamento preventivo para Neovim 0.10+
      pcall(vim.treesitter.language.register, "tsx", "typescriptreact")
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
    },
  },
}
