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
  on_attach = function(_, bufnr)
    local opts = { buffer = bufnr }

    map_lsp_key("n", "gR", "<cmd>Telescope lsp_references<CR>", "Show LSP references", opts)
    map_lsp_key("n", "gD", vim.lsp.buf.declaration, "Go to declaration", opts)
    map_lsp_key("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions", opts)
    map_lsp_key("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations", opts)
    map_lsp_key("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions", opts)
    map_lsp_key({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, "Code actions", opts)
    map_lsp_key({ "n", "v" }, "<leader>r", vim.lsp.buf.rename, "Rename symbol", opts)
    map_lsp_key("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Buffer diagnostics", opts)
    map_lsp_key("n", "<leader>d", vim.diagnostic.open_float, "Line diagnostics", opts)
    map_lsp_key("n", "[d", goto_previous_diagnostic, "Previous diagnostic", opts)
    map_lsp_key("n", "]d", goto_next_diagnostic, "Next diagnostic", opts)
    map_lsp_key("n", "K", vim.lsp.buf.hover, "Hover documentation", opts)
    map_lsp_key("n", "<leader>rs", "<cmd>LspRestart<CR>", "Restart LSP", opts)
  end,
}
