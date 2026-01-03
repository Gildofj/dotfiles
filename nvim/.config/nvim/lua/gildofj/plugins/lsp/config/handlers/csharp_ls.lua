return {
  cmd = { "omnisharp" },
  filetypes = { "cs", "vb" }, -- cs para C#, vb para Visual Basic
  root_dir = require("lspconfig.util").root_pattern("*.sln", "*.csproj", ".git"),
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
}
