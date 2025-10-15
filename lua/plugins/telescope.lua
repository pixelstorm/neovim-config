--[[
╭─────────────────────────────────────────────────────────────╮
│                    Telescope Configuration                  │
│                                                             │
│  Fuzzy finder with FZF integration                          │
╰─────────────────────────────────────────────────────────────╯
--]]

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    },
    keys = {
      {
        "<leader>,",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
        desc = "Switch Buffer",
      },
      {
        "<leader>/",
        function()
          local git_root = vim.fn.finddir('.git', '.;')
          if git_root ~= '' then
            git_root = vim.fn.fnamemodify(git_root, ':h')
            require("telescope.builtin").live_grep({ cwd = git_root })
          else
            require("telescope.builtin").live_grep()
          end
        end,
        desc = "Grep (git root)"
      },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      {
        "<leader><space>",
        function()
          local git_root = vim.fn.finddir('.git', '.;')
          if git_root ~= '' then
            git_root = vim.fn.fnamemodify(git_root, ':h')
            require("telescope.builtin").find_files({ cwd = git_root })
          else
            require("telescope.builtin").find_files()
          end
        end,
        desc = "Find Files (git root)"
      },
      -- find
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
      { "<leader>fc", "<cmd>Telescope find_files cwd=~/.config/nvim<cr>", desc = "Find Config File" },
      {
        "<leader>ff",
        function()
          local git_root = vim.fn.finddir('.git', '.;')
          if git_root ~= '' then
            git_root = vim.fn.fnamemodify(git_root, ':h')
            require("telescope.builtin").find_files({ cwd = git_root })
          else
            require("telescope.builtin").find_files()
          end
        end,
        desc = "Find Files (git root)"
      },
      { "<leader>fF", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", desc = "Find Files (all)" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      { "<leader>fR", "<cmd>Telescope oldfiles cwd_only=true<cr>", desc = "Recent (cwd)" },
      -- git
      { "<leader>gC", "<cmd>Telescope git_commits<CR>", desc = "Git Commits (Telescope)" },
      { "<leader>gS", "<cmd>Telescope git_status<CR>", desc = "Git Status (Telescope)" },
      -- search
      { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
      {
        "<leader>sg",
        function()
          local git_root = vim.fn.finddir('.git', '.;')
          if git_root ~= '' then
            git_root = vim.fn.fnamemodify(git_root, ':h')
            require("telescope.builtin").live_grep({ cwd = git_root })
          else
            require("telescope.builtin").live_grep()
          end
        end,
        desc = "Grep (git root)"
      },
      { "<leader>sG", "<cmd>Telescope live_grep cwd=false<cr>", desc = "Grep (cwd)" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
      {
        "<leader>sw",
        function()
          local git_root = vim.fn.finddir('.git', '.;')
          if git_root ~= '' then
            git_root = vim.fn.fnamemodify(git_root, ':h')
            require("telescope.builtin").grep_string({ cwd = git_root, word_match = "-w" })
          else
            require("telescope.builtin").grep_string({ word_match = "-w" })
          end
        end,
        desc = "Word (git root)"
      },
      { "<leader>sW", "<cmd>Telescope grep_string cwd=false word_match=-w<cr>", desc = "Word (cwd)" },
      {
        "<leader>sw",
        function()
          local git_root = vim.fn.finddir('.git', '.;')
          if git_root ~= '' then
            git_root = vim.fn.fnamemodify(git_root, ':h')
            require("telescope.builtin").grep_string({ cwd = git_root })
          else
            require("telescope.builtin").grep_string()
          end
        end,
        mode = "v",
        desc = "Selection (git root)"
      },
      { "<leader>sW", "<cmd>Telescope grep_string cwd=false<cr>", mode = "v", desc = "Selection (cwd)" },
      { "<leader>uC", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "Colorscheme with preview" },
      {
        "<leader>ss",
        function()
          require("telescope.builtin").lsp_document_symbols({
            symbols = {
              "Class",
              "Function",
              "Method",
              "Constructor",
              "Interface",
              "Module",
              "Struct",
              "Trait",
              "Field",
              "Property",
            },
          })
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols({
            symbols = {
              "Class",
              "Function",
              "Method",
              "Constructor",
              "Interface",
              "Module",
              "Struct",
              "Trait",
              "Field",
              "Property",
            },
          })
        end,
        desc = "Goto Symbol (Workspace)",
      },
    },
    opts = function()
      local actions = require("telescope.actions")

      local open_with_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
      end
      local open_selected_with_trouble = function(...)
        return require("trouble.providers.telescope").open_selected_with_trouble(...)
      end

      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_selected_with_trouble,
              ["<a-i>"] = function()
                require("telescope.builtin").find_files({ no_ignore = true })
              end,
              ["<a-h>"] = function()
                require("telescope.builtin").find_files({ hidden = true })
              end,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
    end,
  },

  -- FZF integration for better performance
  {
    "junegunn/fzf",
    build = "./install --bin",
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    keys = {
      { "<leader>fz", "<cmd>Files<cr>", desc = "FZF Files" },
      { "<leader>fZ", "<cmd>GFiles<cr>", desc = "FZF Git Files" },
      { "<leader>fl", "<cmd>Lines<cr>", desc = "FZF Lines" },
      { "<leader>fL", "<cmd>BLines<cr>", desc = "FZF Buffer Lines" },
      { "<leader>ft", "<cmd>Tags<cr>", desc = "FZF Tags" },
      { "<leader>fT", "<cmd>BTags<cr>", desc = "FZF Buffer Tags" },
      { "<leader>fh", "<cmd>History<cr>", desc = "FZF History" },
      { "<leader>f:", "<cmd>History:<cr>", desc = "FZF Command History" },
      { "<leader>f/", "<cmd>History/<cr>", desc = "FZF Search History" },
      { "<leader>fm", "<cmd>Marks<cr>", desc = "FZF Marks" },
      { "<leader>fw", "<cmd>Windows<cr>", desc = "FZF Windows" },
      { "<leader>fM", "<cmd>Maps<cr>", desc = "FZF Keymaps" },
      { "<leader>fH", "<cmd>Helptags<cr>", desc = "FZF Help" },
      { "<leader>fC", "<cmd>Colors<cr>", desc = "FZF Colorschemes" },
      { "<leader>fA", "<cmd>Ag<cr>", desc = "FZF Ag" },
      { "<leader>fR", "<cmd>Rg<cr>", desc = "FZF Ripgrep" },
    },
    config = function()
      -- FZF configuration
      vim.g.fzf_preview_window = { "right:50%", "ctrl-/" }
      vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }
      
      -- Custom FZF colors to match Tokyo Night theme
      vim.g.fzf_colors = {
        fg = { "fg", "Normal" },
        bg = { "bg", "Normal" },
        hl = { "fg", "Comment" },
        ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
        ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
        ["hl+"] = { "fg", "Statement" },
        info = { "fg", "PreProc" },
        border = { "fg", "Ignore" },
        prompt = { "fg", "Conditional" },
        pointer = { "fg", "Exception" },
        marker = { "fg", "Keyword" },
        spinner = { "fg", "Label" },
        header = { "fg", "Comment" },
      }
    end,
  },
}