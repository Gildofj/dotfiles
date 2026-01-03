return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = function(term)
      if term.direction == "vertical" then
        return vim.o.columns * 0.4
      else
        return 20
      end
    end,
    shell = Utils.is_win() and "pwsh.exe" or vim.o.shell,
    direction = "horizontal",
    hide_number = true,
    shade_filetypes = {},
    shade_terminals = false,
    start_in_insert = false,
    insert_mappings = true,
    persist_size = true,
    persist_mode = true,
    close_on_exit = true,
    auto_scroll = true,
  },
  config = function(_, opts)
    local toggleterm = require("toggleterm")
    toggleterm.setup(opts)

    local terminal = require("toggleterm.terminal")
    local function get_current_terminal()
      local termId = terminal.get_focused_id()
      return terminal.get(termId)
    end

    local function close_current_terminal()
      get_current_terminal():shutdown()
    end

    local function smart_toggle()
      local terms = terminal.get_all(true)
      if #terms == 0 then
        toggleterm.toggle()
      else
        toggleterm.toggle_all()
      end
    end

    local Terminal = terminal.Terminal
    local term_right = Terminal:new({ direction = "vertical" })
    local function openTermRight()
      vim.cmd("stopinsert!")
      vim.cmd("vsplit!")
      vim.cmd("wincmd l!")
      term_right:open()
      vim.cmd("wincmd =!")
    end

    vim.keymap.set({ "n", "x", "o" }, "<C-t>", smart_toggle, { desc = "ToggleTerm" })

    -- Terminal mode keybindings
    -- TODO: Verificar porque esse comando não esta abrindo um terminal ao lado
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { desc = "Enable normal mode" })
    vim.keymap.set("t", "<C-n>", openTermRight, { desc = "New terminal on right" })
    vim.keymap.set("t", "<C-o>", close_current_terminal, { desc = "Close current terminal" })

    vim.api.nvim_create_autocmd("QuitPre", {
      callback = function()
        local ok, toggle_terminal = pcall(require, "toggleterm.terminal")
        -- stylua: ignore
        if not ok then return end
        for _, term in pairs(toggle_terminal.get_all(true)) do
          term:shutdown()
        end
      end,
    })
  end,
}
