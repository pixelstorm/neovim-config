-- Load nvim-cmp
local cmp = require('cmp')

-- nvim-cmp setup
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- Use UltiSnips for snippet expansion
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-Space>'] = cmp.mapping.complete(), -- Trigger completion menu
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- LSP completions
    { name = 'ultisnips' }, -- UltiSnips snippets
    { name = 'buffer' }, -- Buffer completions
    { name = 'path' }, -- Path completions
  }),
})

-- Enable LSP servers
local lspconfig = require('lspconfig')
lspconfig.marksman.setup {} -- For Markdown
