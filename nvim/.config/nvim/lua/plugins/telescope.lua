return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "ThePrimeagen/harpoon",
    },
    config = function()
      local opts = { noremap = true, silent = true }
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")

      -- set telescope config and set extensions
      require("telescope").setup({
        defaults = {
          path_display = { "truncate " },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous, -- move to prev result
              ["<C-j>"] = actions.move_selection_next, -- move to next result
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      -- load extensions
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("harpoon")

      -- keymaps
      opts.desc = "Fuzzy find files"
      vim.keymap.set("n", "<C-p>", builtin.find_files, opts)
      opts.desc = "Find recent files"
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, opts)
      opts.desc = "Find string"
      vim.keymap.set("n", "<leader>fs", builtin.live_grep, opts)
      opts.desc = "Find string under cursor"
      vim.keymap.set("n", "<leader>fc", builtin.grep_string, opts)
    end,
  },
}
