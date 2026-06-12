return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      local install = require("nvim-treesitter.install")
      install.prefer_git = true
      if vim.fn.has("win32") == 1 then
        install.compilers = { "cl", "gcc", "clang" }
      elseif vim.fn.has("mac") == 1 then
        install.compilers = { "clang", "cc", "gcc" }
        local sdk_path = vim.fn.trim(vim.fn.system("xcrun --show-sdk-path"))
        if sdk_path ~= "" then
          vim.env.SDKROOT = sdk_path
        end
      else
        install.compilers = { "gcc", "clang", "cc" }
      end

      ts.setup()

      local parsers = {
        "bash", "c", "diff", "html", "javascript", "jsdoc", "json", "jsonc", "lua", "luadoc", "luap",
        "markdown", "markdown_inline", "python", "query", "regex", "toml", "tsx", "typescript", "vim",
        "vimdoc", "yaml", "rust", "astro", "css", "scss", "sql"
      }

      if #vim.api.nvim_list_uis() == 0 then
        pcall(function()
          ts.install(parsers):wait(300000)
        end)
      else
        vim.defer_fn(function()
          if ts.install then
            ts.install(parsers)
          end
        end, 0)
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local ok = pcall(vim.treesitter.start)
          if ok then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      pcall(vim.treesitter.language.register, "tsx", "typescriptreact")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
          },
        },
      })
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
