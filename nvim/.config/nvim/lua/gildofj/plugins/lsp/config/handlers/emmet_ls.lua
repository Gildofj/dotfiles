return {
  cmd = { "emmet-ls", "--stdio" },
  filetypes = {
    "html",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "svelte",
    "xml",
    "css",
    "sass",
    "scss",
    "less",
  },
  init_options = {
    html = {
      options = {
        ["bem.enabled"] = true,
      },
    },
  },
}
