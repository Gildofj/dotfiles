return {
  settings = {
    Lua = {
      -- make the language server recognize "vim" global
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
}
