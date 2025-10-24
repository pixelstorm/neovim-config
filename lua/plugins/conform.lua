--[[
╭─────────────────────────────────────────────────────────────╮
│                    Conform.nvim Configuration               │
│                                                             │
│  Code formatting with conform.nvim                         │
╰─────────────────────────────────────────────────────────────╯
--]]

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        vim.notify("Conform plugin keymap triggered!", vim.log.levels.INFO)
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
      scss = { "prettierd", "prettier", stop_after_first = true },
      html = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },
      php = { "php_mixed_formatter", "prettierd", "prettier", stop_after_first = true }, -- Mixed PHP/HTML formatting
      twig = { "twig_indent" },
      ["html.twig"] = { "twig_indent" },
    },
    -- Disable automatic formatting on save to prevent file corruption
    format_on_save = false,
    formatters = {
      -- Smart PHP formatter that handles mixed PHP/HTML content
      php_mixed_formatter = {
        command = function(self, ctx)
          -- Check if file contains significant HTML content
          local content = table.concat(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false), "\n")
          local html_tags = content:match("<html") or content:match("<!DOCTYPE") or
                           content:match("<head") or content:match("<body") or
                           (content:match("<%?php") and content:match("<[^?]"))
          
          if html_tags then
            -- File contains HTML, use prettier for mixed content
            return "prettier"
          else
            -- Pure PHP file, use php-cs-fixer if available
            if vim.fn.executable("php-cs-fixer") == 1 then
              return "php-cs-fixer"
            else
              return "prettier" -- Fallback to prettier
            end
          end
        end,
        args = function(self, ctx)
          local content = table.concat(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false), "\n")
          local html_tags = content:match("<html") or content:match("<!DOCTYPE") or
                           content:match("<head") or content:match("<body") or
                           (content:match("<%?php") and content:match("<[^?]"))
          
          if html_tags then
            -- Prettier args for PHP files with HTML
            return {
              "--stdin-filepath", "$FILENAME",
              "--parser", "php",
              "--print-width", "120",
              "--tab-width", "2",
              "--use-tabs", "false",
            }
          else
            -- php-cs-fixer args for pure PHP
            return {
              "fix",
              "--rules=@PSR12,@Symfony",
              "--allow-risky=yes",
              "$FILENAME",
            }
          end
        end,
        stdin = function(self, ctx)
          local content = table.concat(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false), "\n")
          local html_tags = content:match("<html") or content:match("<!DOCTYPE") or
                           content:match("<head") or content:match("<body") or
                           (content:match("<%?php") and content:match("<[^?]"))
          return html_tags -- Use stdin for prettier, file for php-cs-fixer
        end,
      },
      
      php_cs_fixer = {
        command = "php-cs-fixer",
        args = {
          "fix",
          "--rules=@PSR12,@Symfony",
          "--allow-risky=yes",
          "$FILENAME",
        },
        stdin = false,
      },
      
      phpcbf = {
        command = "phpcbf",
        args = {
          "--standard=PSR12",
          "$FILENAME",
        },
        stdin = false,
      },
      
      -- Simplified Twig formatter that avoids complex processing
      twig_indent = {
        command = "cat", -- Just pass through content unchanged for now
        args = {},
        stdin = true,
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    vim.notify("Conform.nvim initialized successfully!", vim.log.levels.INFO)
  end,
  config = function(_, opts)
    vim.notify("Conform.nvim config function called", vim.log.levels.INFO)
    require("conform").setup(opts)
    vim.notify("Conform.nvim setup completed", vim.log.levels.INFO)
  end,
}