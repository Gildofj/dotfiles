return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "L3MON4D3/LuaSnip", version = "*", build = "make install_jsregexp" }, -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- for autocompletion
      "rafamadriz/friendly-snippets", -- useful snippets

      "hrsh7th/cmp-nvim-lsp", -- source for LSP completion
      "hrsh7th/cmp-nvim-lua", -- source for lua completions
      "hrsh7th/cmp-calc", -- source for some calc
      "hrsh7th/cmp-emoji", -- source for emojis
      "hrsh7th/cmp-buffer", -- source for text in buffer
      "hrsh7th/cmp-path", -- source for file system paths
    },
    opts = function()
      local luasnip = require("luasnip")
      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      return {
        completion = {
          completeopt = "menu,menuone,preview,noselect",
        },
        snippet = { -- configure how nvim-cmp interacts with snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = require("gildofj.plugins.cmp.mapping"),
        sources = require("gildofj.plugins.cmp.sources"),
        formatting = require("gildofj.plugins.cmp.formatting"),
        experimental = {
          ghost_text = vim.g.ai_cmp and {
            hl_group = "CmpGhostText",
          } or false,
        },
      }
    end,
  },
}
