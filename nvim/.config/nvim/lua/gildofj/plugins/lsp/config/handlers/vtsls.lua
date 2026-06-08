return {
  cmd = { "vtsls", "--stdio" },
  filetypes = {
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "json5",
    "yaml",
    "yml",
  },
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = false, -- Avoid workspace TS conflicts
    },
  },
}
