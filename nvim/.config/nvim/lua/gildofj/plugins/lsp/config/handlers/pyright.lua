return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "py" },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
      },
    },
  },
}
