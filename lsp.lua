local lspconfig = require("lspconfig")

lspconfig.tailwindcss.setup({
  cmd = { "tailwindcss-language-server", "--stdio" }, -- Specify the communication protocol
  filetypes = { "html", "twig", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { "class=\"([^\"]+)\"", 1 }, -- HTML with double quotes
          { "class='([^']+)'", 1 },   -- HTML with single quotes
        },
      },
    },
  },
})

-- Add configuration for marksman or other Markdown LSP
lspconfig.marksman.setup {
  on_attach = function(client, bufnr)
    -- Enable omnifunc and formatting on attach if desired
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  end,
  capabilities = require('cmp_nvim_lsp').default_capabilities()
}
