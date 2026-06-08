return {
  cmd = { "rust-analyzer" },
  filetypes = { "rs" },
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = { command = "clippy" },
    },
  },
}
