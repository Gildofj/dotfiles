local map_lsp_key = function(mode, lhs, rhs, desc, opts)
  opts = vim.tbl_extend("force", opts or {}, { desc = desc, noremap = true, silent = true })
  vim.keymap.set(mode, lhs, rhs, opts)
end

local goto_previous_diagnostic = function()
  vim.diagnostic.jump({ count = -1 })
end

local goto_next_diagnostic = function()
  vim.diagnostic.jump({ count = 1 })
end

return {
  on_attach = function(client, buffr)
    local opts = { buffer = buffr }
    -- set keybinds
    opts.desc = "Show LSP references"
    map_lsp_key("n", "gR", ":Telescope lsp_references<CR>", opts)

    opts.desc = "Go to declaration"
    map_lsp_key("n", "gD", vim.lsp.buf.declaration, opts)

    opts.desc = "Show LSP definitions"
    map_lsp_key("n", "gd", ":Telescope lsp_definitions<CR>", opts)

    opts.desc = "Show LSP implementations"
    map_lsp_key("n", "gi", ":Telescope lsp_implementations<CR>", opts)

    opts.desc = "Show LSP type definitions"
    map_lsp_key("n", "gt", ":Telescope lsp_type_definitions<CR>", opts)

    opts.desc = "See available code actions"
    map_lsp_key({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)

    opts.desc = "Smart rename"
    map_lsp_key({ "n", "v" }, "<leader>r", vim.lsp.buf.rename, opts)

    opts.desc = "Show buffer diagnostics"
    map_lsp_key("n", "<leader>D", ":Telescope diagnostics bufnr=0<CR>", opts)

    opts.desc = "Show line diagnostics"
    map_lsp_key("n", "<leader>d", vim.diagnostic.open_float, opts)

    opts.desc = "Go to previous diagnostic"
    map_lsp_key("n", "[d", goto_previous_diagnostic, opts)

    opts.desc = "Go to next diagnostic"
    map_lsp_key("n", "]d", goto_next_diagnostic, opts)

    opts.desc = "Show documentation for what is under cursor"
    map_lsp_key("n", "K", vim.lsp.buf.hover, opts)

    opts.desc = "Restart LSP"
    map_lsp_key("n", "<leader>rs", ":LspRestart<CR>", opts)
  end,
}
