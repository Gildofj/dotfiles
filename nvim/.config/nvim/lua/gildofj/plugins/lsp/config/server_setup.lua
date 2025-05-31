local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local keymaps = require("gildofj.plugins.lsp.config.keymaps")
local ensure_installed_servers = require("gildofj.plugins.lsp.config.ensure_installed_servers")

local function setup_server(server, config)
  config.capabilities = capabilities
  config.on_attach = keymaps.on_attach

  lspconfig[server].setup(config)
end

local function configure_server(server_name)
  local has_handler, config = pcall(require, "gildofj.plugins.lsp.config.handlers." .. server_name)
  if has_handler then
    setup_server(server_name, config)
  else
    setup_server(server_name, {})
  end
end

return {
  run = function()
    for _, server in ipairs(ensure_installed_servers) do
      configure_server(server)
    end
  end,
}
