return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  lazy = false,
  opts = function()
    local command = require("neo-tree.command")
    vim.keymap.set("n", "<C-b>", ":Neotree filesystem reveal left<CR>")
    vim.keymap.set("n", "<C-S-b>", ":Neotree filesystem action=close<CR>")
    vim.keymap.set("n", "<C-g>", ":Neotree git_status reveal left<CR>")
    vim.keymap.set("n", "<C-S-g>", ":Neotree git_status action=close<CR>")

    --@type neotree.Config
    return {
      filesystem = {
        use_libuv_watcher = true,
        follow_current_file = {
          enabled = true,
        },
        window = {
          auto_preview = true, -- 👈 preview automático
        },
      },
      window = {
        mappings = {
          ["P"] = {
            "toggle_preview",
            config = {
              use_float = false,
              use_image_nvim = true,
            },
          },
        },
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            command.execute({ action = "close" })
          end,
        },
        {
          event = "file_renamed",
          handler = function(args)
            print("File " .. args.source .. " renamed to " .. args.destination)
          end,
        },
        {
          event = "file_moved",
          handler = function(args)
            print("File " .. args.source .. " moved to " .. args.destination)
          end,
        },
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.cmd("highlight! Cursor blend=100")
          end,
        },
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            vim.cmd("wincmd =")
          end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function(args)
            vim.cmd("wincmd =")
          end,
        },
      },
      default_component_configs = {},
    }
  end,
}
