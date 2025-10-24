--[[
╭─────────────────────────────────────────────────────────────╮
│                    PHP & WordPress Development              │
│                                                             │
│  Enhanced tools for PHP and WordPress development          │
╰─────────────────────────────────────────────────────────────╯
--]]

return {
  -- Advanced PHP language server
  {
    "phpactor/phpactor",
    build = "composer install --no-dev -o",
    ft = "php",
    keys = {
      { "<leader>pm", "<cmd>PhpactorContextMenu<cr>", desc = "Phpactor context menu" },
      { "<leader>pn", "<cmd>PhpactorClassNew<cr>", desc = "Phpactor new class" },
      { "<leader>pe", "<cmd>PhpactorClassExpand<cr>", desc = "Phpactor expand class" },
      { "<leader>pv", "<cmd>PhpactorMoveFile<cr>", desc = "Phpactor move file" },
      { "<leader>pc", "<cmd>PhpactorCopyFile<cr>", desc = "Phpactor copy file" },
      { "<leader>pr", "<cmd>PhpactorTransform<cr>", desc = "Phpactor transform" },
    },
  },

  -- Note: Removed gbprod/phpactor.nvim as it was causing installation prompts
  -- The main phpactor/phpactor plugin above provides all necessary functionality

  -- Enhanced Emmet support for HTML in PHP
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "scss", "javascript", "php" },
    config = function()
      vim.g.user_emmet_settings = {
        php = {
          extends = 'html',
          filters = 'html',
        },
        html = {
          default_attributes = {
            option = { value = nil },
            textarea = { id = nil, name = nil, cols = 10, rows = 10 },
          },
          snippets = {
            html = '<!DOCTYPE html>\n'
              .. '<html lang="${lang}">\n'
              .. '<head>\n'
              .. '\t<meta charset="${charset}">\n'
              .. '\t<title></title>\n'
              .. '\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n'
              .. '</head>\n'
              .. '<body>\n\t${child}|\n</body>\n'
              .. '</html>',
          },
        },
      }
      
      -- Enable Emmet for PHP files
      vim.g.user_emmet_install_global = 0
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "html", "css", "scss", "javascript", "php" },
        callback = function()
          vim.cmd("EmmetInstall")
        end,
      })
    end,
  },

  -- Note: vscode-es7-react-js-snippets removed due to installation issues
  -- You can manually install JavaScript snippets if needed later

  -- Laravel/PHP framework support (useful for modern PHP development)
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "nvim-neotest/nvim-nio", -- Required dependency
    },
    cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
    keys = {
      { "<leader>la", ":Laravel artisan<cr>", desc = "Laravel artisan" },
      { "<leader>lr", ":Laravel routes<cr>", desc = "Laravel routes" },
      { "<leader>lm", ":Laravel related<cr>", desc = "Laravel related" },
    },
    event = { "VeryLazy" },
    config = function()
      -- Only setup if nio is available
      local nio_ok, _ = pcall(require, "nio")
      if not nio_ok then
        vim.notify("Laravel.nvim requires nvim-nio, but it's not available", vim.log.levels.WARN)
        return
      end
      
      require("laravel").setup({
        lsp_server = "intelephense",
        features = {
          null_ls = {
            enable = false,
          },
        },
      })
    end,
  },

  -- Enhanced PHP debugging support
  {
    "vim-vdebug/vdebug",
    ft = "php",
    config = function()
      vim.g.vdebug_options = {
        port = 9003,
        server = '127.0.0.1',
        timeout = 20,
        on_close = 'detach',
        break_on_open = 1,
        ide_key = '',
        path_maps = {},
        debug_window_level = 0,
        debug_file_level = 0,
        debug_file = '',
        watch_window_style = 'expanded',
        marker_default = '⬦',
        marker_closed_tree = '▸',
        marker_open_tree = '▾'
      }
    end,
  },

  -- WordPress specific enhancements
  {
    "stephpy/vim-php-cs-fixer",
    ft = "php",
    config = function()
      vim.g.php_cs_fixer_rules = "@PSR12,@Symfony"
      vim.g.php_cs_fixer_cache = ".php_cs.cache"
      vim.g.php_cs_fixer_config_file = ".php_cs"
    end,
  },
}