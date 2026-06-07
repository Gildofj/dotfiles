return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = {
    -- Core CSS filetypes
    "css",
    "scss",
    "sass",
    "less",

    -- HTML/JS/TS frameworks
    "html",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",

    "astro",

    "vue",
    "svelte",
    "heex", -- Phoenix/Elixir
  },
  init_options = {
    userLanguages = {
      astro = "html", -- Treat Astro as HTML
    },
  },
}
