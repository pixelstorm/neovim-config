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
      -- php = { "php_cs_fixer" }, -- DISABLED: PHP formatting removed
      twig = { "twig_indent" },
      ["html.twig"] = { "twig_indent" },
    },
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
    formatters = {
      php_cs_fixer = {
        command = "php-cs-fixer",
        args = {
          "fix",
          "--rules=@PSR12",
          "$FILENAME",
        },
        stdin = false,
      },
      -- Simplified Twig formatter that avoids complex processing
      twig_indent = {
        command = "cat", -- Just pass through content unchanged for now
        args = {},
        stdin = true,
        -- Add logging to debug formatter execution
        prepend_args = function(self, ctx)
          vim.notify("DEBUG: twig_indent formatter called for " .. ctx.filename, vim.log.levels.INFO)
          return {}
        end,
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}