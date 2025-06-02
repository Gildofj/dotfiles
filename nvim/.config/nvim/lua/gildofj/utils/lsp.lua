---@class gildofj.utils.lsp
local M = {}

---@class GetClientsParams
---@field bufnr? number O buffer alvo (padrão: buffer atual)

---Retorna os LSP clients conectados a um buffer específico.
---@param opts GetClientsParams
---@return table
function M.get_clients(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  return vim.lsp.get_clients({ bufnr = bufnr })
end

return M
