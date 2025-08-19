--[[
╭─────────────────────────────────────────────────────────────╮
│                    Neogit Configuration                     │
│                                                             │
│  Modern Git interface for Neovim                           │
╰─────────────────────────────────────────────────────────────╯
--]]

return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    event = "VeryLazy",
    config = true,
    keys = {
      {
        "<leader>gg",
        function()
          -- Find git repository relative to current buffer
          local current_file = vim.fn.expand('%:p')
          local git_dir = vim.fn.finddir('.git', current_file .. ';')
          if git_dir ~= '' then
            -- Change to the git repository root
            local git_root = vim.fn.fnamemodify(git_dir, ':h')
            vim.cmd('cd ' .. git_root)
          end
          require("neogit").open()
        end,
        desc = "Neogit Status"
      },
      {
        "<leader>gc",
        function()
          local current_file = vim.fn.expand('%:p')
          local git_dir = vim.fn.finddir('.git', current_file .. ';')
          if git_dir ~= '' then
            local git_root = vim.fn.fnamemodify(git_dir, ':h')
            vim.cmd('cd ' .. git_root)
          end
          require("neogit").open({ "commit" })
        end,
        desc = "Neogit Commit"
      },
      {
        "<leader>gp",
        function()
          local current_file = vim.fn.expand('%:p')
          local git_dir = vim.fn.finddir('.git', current_file .. ';')
          if git_dir ~= '' then
            local git_root = vim.fn.fnamemodify(git_dir, ':h')
            vim.cmd('cd ' .. git_root)
          end
          require("neogit").open({ "push" })
        end,
        desc = "Neogit Push"
      },
      {
        "<leader>gl",
        function()
          local current_file = vim.fn.expand('%:p')
          local git_dir = vim.fn.finddir('.git', current_file .. ';')
          if git_dir ~= '' then
            local git_root = vim.fn.fnamemodify(git_dir, ':h')
            vim.cmd('cd ' .. git_root)
          end
          require("neogit").open({ "pull" })
        end,
        desc = "Neogit Pull"
      },
      {
        "<leader>gs",
        function()
          local current_file = vim.fn.expand('%:p')
          local git_dir = vim.fn.finddir('.git', current_file .. ';')
          if git_dir ~= '' then
            local git_root = vim.fn.fnamemodify(git_dir, ':h')
            vim.cmd('cd ' .. git_root)
          end
          require("neogit").open({ kind = "split" })
        end,
        desc = "Neogit Status (Split)"
      },
      {
        "<leader>gt",
        function()
          local current_file = vim.fn.expand('%:p')
          local git_dir = vim.fn.finddir('.git', current_file .. ';')
          if git_dir ~= '' then
            local git_root = vim.fn.fnamemodify(git_dir, ':h')
            vim.cmd('cd ' .. git_root)
          end
          require("neogit").open({ kind = "tab" })
        end,
        desc = "Neogit Status (Tab)"
      },
    },
    opts = {
      -- Hides the hints at the top of the status buffer
      disable_hint = false,
      -- Disables changing the buffer highlights based on if the buffer is focused.
      disable_context_highlighting = false,
      -- Disables signs for sections/items/hunks
      disable_signs = false,
      -- Changes what mode the Commit Editor starts in. `true` will leave nvim in normal mode, `false` will change nvim to
      -- insert mode, and `"auto"` will change nvim to insert mode IF the commit message is empty, otherwise leaving it in
      -- normal mode.
      disable_insert_on_commit = "auto",
      -- When enabled, will watch the `.git/` directory for changes and refresh the status buffer in response to filesystem
      -- events.
      filewatcher = {
        interval = 1000,
        enabled = true,
      },
      -- Used to generate URL's for branch popup action "pull request".
      git_services = {
        ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
        ["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
        ["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/-/merge_requests/new?merge_request[source_branch]=${branch_name}",
      },
      -- Allows a different telescope sorter. Defaults to 'fuzzy_with_index_bias'
      telescope_sorter = function()
        return require("telescope").extensions.fzf.native_fzf_sorter()
      end,
      -- Persist the values of switches/options within and across sessions
      remember_settings = true,
      -- Scope persisted settings on a per-project basis
      use_per_project_settings = true,
      -- Table of settings to never persist. Uses format "Filetype--cli-value"
      ignored_settings = {
        "NeogitPushPopup--force-with-lease",
        "NeogitPushPopup--force",
        "NeogitPullPopup--rebase",
        "NeogitCommitPopup--allow-empty",
        "NeogitRevertPopup--no-edit",
      },
      -- Configure highlight group features
      highlight = {
        italic = true,
        bold = true,
        underline = true
      },
      -- Set to false if you want to be responsible for creating _ALL_ keymappings
      use_default_keymaps = true,
      -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
      -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you have run a git command.
      auto_refresh = true,
      -- Value used for `--sort` option for `git branch` command
      -- By default, branches will be sorted by commit date descending
      -- Flag description: https://git-scm.com/docs/git-branch#Documentation/git-branch.txt---sortltkeygt
      sort_branches = "-committerdate",
      -- Change the default way of opening neogit
      kind = "tab",
      -- Disable line numbers and relative line numbers
      disable_line_numbers = true,
      -- The time after which an output console is shown for slow running commands
      console_timeout = 2000,
      -- Automatically show console if a command takes more than console_timeout milliseconds
      auto_show_console = true,
      status = {
        recent_commit_count = 10,
      },
      commit_editor = {
        kind = "tab",
      },
      commit_select_view = {
        kind = "tab",
      },
      commit_view = {
        kind = "vsplit",
        verify_commit = os.execute("which gpg") == 0, -- Can be set to true or false, otherwise we try to find the binary
      },
      log_view = {
        kind = "tab",
      },
      rebase_editor = {
        kind = "tab",
      },
      reflog_view = {
        kind = "tab",
      },
      merge_editor = {
        kind = "tab",
      },
      tag_editor = {
        kind = "tab",
      },
      preview_buffer = {
        kind = "split",
      },
      popup = {
        kind = "split",
      },
      signs = {
        -- { CLOSED, OPENED }
        hunk = { "", "" },
        item = { ">", "v" },
        section = { ">", "v" },
      },
      -- Each Integration is auto-detected through plugin presence, however, it can be disabled by setting to `false`
      integrations = {
        -- If enabled, use telescope for menu selection rather than vim.ui.select.
        -- Allows multi-select and some things that vim.ui.select doesn't.
        telescope = true,
        -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `diffview`.
        -- The diffview integration enables the diff popup
        --
        -- Requires you to have `sindrets/diffview.nvim` installed.
        diffview = true,

        -- If enabled, uses fzf-lua for menu selection. If the telescope integration
        -- is also enabled, telescope will take precedence.
        fzf_lua = false,
      },
    }
  },

  -- Diffview for better diff viewing
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "DiffView File History" },
    },
    opts = {
      diff_binaries = false,    -- Show diffs for binaries
      enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
      git_cmd = { "git" },      -- The git executable followed by default args.
      use_icons = true,         -- Requires nvim-web-devicons
      show_help_hints = true,   -- Show help hints in the wild menu
      watch_index = true,       -- Update views and index on git index changes
      icons = {                 -- Only applies when use_icons is true.
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      view = {
        -- Configure the layout and behavior of different types of views.
        -- Available layouts:
        --  'diff1_plain'
        --    |'diff2_horizontal'
        --    |'diff2_vertical'
        --    |'diff3_horizontal'
        --    |'diff3_vertical'
        --    |'diff3_mixed'
        --    |'diff4_mixed'
        -- For more info, see ':h diffview-config-view.x.layout'.
        default = {
          -- Config for changed files, and staged files in diff views.
          layout = "diff2_horizontal",
          winbar_info = false,          -- See ':h diffview-config-view.x.winbar_info'
        },
        merge_tool = {
          -- Config for conflicted files in diff views during a merge or rebase.
          layout = "diff3_horizontal",
          disable_diagnostics = true,   -- Temporarily disable diagnostics for conflict buffers while in the view.
          winbar_info = true,           -- See ':h diffview-config-view.x.winbar_info'
        },
        file_history = {
          -- Config for changed files in file history views.
          layout = "diff2_horizontal",
          winbar_info = false,          -- See ':h diffview-config-view.x.winbar_info'
        },
      },
    },
  },
}