return {
  cmd = { "lua-language-server", "--stdio" },
  filetypes = { "lua" }, -- Barreira crucial: não anexa em TSX/JS
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim", "it", "describe", "before_each", "after_each" },
        unusedLocalExclude = { "_*" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Adiciona os plugins ao workspace para melhor autocompletar
          "${3rd}/luv/library",
          "${3rd}/busted/library",
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
