-- Get platform dependant build script
local function tabnine_build_path()
  -- Replace vim.uv with vim.loop if using NVIM 0.9.0 or below
  if vim.uv.os_uname().sysname == "Windows_NT" then
    return "pwsh.exe -file .\\dl_binaries.ps1"
  else
    return "./dl_binaries.sh"
  end
end

return {
  "codota/tabnine-nvim",
  build = tabnine_build_path(),
  dependencies = {
      "L3MON4D3/LuaSnip", -- snippet engine
  },
  config = function()
    require("tabnine").setup({
      disable_auto_comment = true,
      accept_keymap = "<Tab>",
      dismiss_keymap = "<C-]>",
      debounce_ms = 800,
      suggestion_color = { gui = "#808080", cterm = 244 },
      exclude_filetypes = { "TelescopePrompt", "NvimTree" },
      log_file_path = nil, -- absolute path to Tabnine log file
    })
    require('tabnine.status').status()
    local luasnip = require("luasnip")
    local keymaps = require("tabnine.keymaps")

    -- keymaps
    local opts = { noremap = true, callback = require("tabnine.chat").open }
    opts.desc = "Open tabnine chat"
    vim.keymap.set({ "n", "x", "i" }, "<leader>q", "", opts)

    vim.keymap.set("i", "<tab>", function()
      if keymaps.has_suggestion() then
        return keymaps.accept_suggestion()
      elseif luasnip.jumpable(1) then
        return luasnip.jump(1)
      else
        return "<tab>"
      end
    end, {expr= true})
  end,
}

