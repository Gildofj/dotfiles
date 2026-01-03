local capabilities = require("cmp_nvim_lsp").default_capabilities()
local keymaps = require("gildofj.plugins.lsp.config.keymaps")
local ensure_installed_servers = require("gildofj.plugins.lsp.config.ensure_installed_servers")

local function setup_server(server, config)
  local full_config = vim.tbl_deep_extend("force", config, {
    capabilities = capabilities,
    on_attach = keymaps.on_attach,
  })

  vim.lsp.config(server, full_config)
end

local function configure_server(server_name)
  local has_handler, config = pcall(require, "gildofj.plugins.lsp.config.handlers." .. server_name)
  if has_handler then
    setup_server(server_name, config)
  else
    setup_server(server_name, {})
  end

  vim.lsp.enable(server_name)
end

return {
  run = function()
    for _, server in ipairs(ensure_installed_servers) do
      configure_server(server)
    end
  end,
}
