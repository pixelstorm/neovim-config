-- LSP configuration using new vim.lsp.config API for Neovim 0.11+
-- with fallback to lspconfig for older versions

local function setup_lsp_server(server_name, config)
  -- Use new vim.lsp.config API if available (Neovim 0.11+)
  if vim.lsp.config and vim.fn.has('nvim-0.11') == 1 then
    vim.lsp.config[server_name] = config
  else
    -- Fallback to lspconfig for older versions
    local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
    if lspconfig_ok and lspconfig[server_name] then
      lspconfig[server_name].setup(config)
    else
      vim.notify(string.format("[LSP ERROR] Could not setup %s: lspconfig not available", server_name), vim.log.levels.ERROR)
    end
  end
end

-- TailwindCSS LSP setup
setup_lsp_server('tailwindcss', {
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

-- Marksman (Markdown LSP) setup
setup_lsp_server('marksman', {
  on_attach = function(client, bufnr)
    -- Enable omnifunc and formatting on attach if desired
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  end,
  capabilities = require('cmp_nvim_lsp').default_capabilities()
})
