return {
  setup = function()
    local mason_lspconfig = require("mason-lspconfig")
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local keymaps = require("plugins.lsp.keymaps")

    local function setup_server(server, config)
      if type(config) == "function" then
        config = config(capabilities, keymaps.on_attach)
      else
        config.capabilities = capabilities
        config.on_attach = keymaps.on_attach
      end

      lspconfig[server].setup(config)
    end

    mason_lspconfig.setup({
      ensure_installed = { "lua_ls", "ts_ls", "cssmodules_ls", "emmet_ls", "html", "jsonls", "tailwindcss", "astro" },
      automatic_enable = true,
      handlers = {
        function(server_name)
          local ok, config = pcall(require, "plugins.lsp.handlers." .. server_name)
          if ok then
            setup_server(server_name, config)
          else
            setup_server(server_name, {})
          end
        end,
      },
    })
  end,
}
