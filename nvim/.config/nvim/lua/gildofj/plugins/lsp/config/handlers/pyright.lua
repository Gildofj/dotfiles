local poetry_env = vim.fn.system("poetry env info -p"):gsub("\n", "")
local python_path = poetry_env .. (Utils.is_win() and "\\Scripts\\python.exe" or "/bin/python")
return {
  settings = {
    python = {
      pythonPath = python_path,
      venvPath = poetry_env,
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
      },
    },
  },
}
