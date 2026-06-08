return {
  cmd = { "astro", "language-server", "--stdio" },
  filetypes = { "astro" },
  settings = {
    astro = {
      -- Disable JSON validation in frontmatter
      validate = {
        json = { enable = false },
        yaml = { enable = true }, -- Astro uses YAML frontmatter
      },
    },
  },
}
