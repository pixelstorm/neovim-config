-- HTML-specific configuration
-- Includes completion mappings and snippet support

-- Tab completion mappings
vim.keymap.set("i", "<Tab>", function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  
  if luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
  elseif cmp.visible() then
    cmp.select_next_item()
  else
    cmp.complete()
  end
end, { buffer = true, desc = "HTML Tab completion" })

vim.keymap.set("i", "<S-Tab>", function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.locally_jumpable(-1) then
    luasnip.jump(-1)
  end
end, { buffer = true, desc = "HTML Shift-Tab completion" })

-- HTML-specific settings
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- Enable auto-closing of HTML tags
vim.opt_local.matchpairs:append("<:>")

-- Debug function for HTML snippets
local function debug_html_snippets()
  local luasnip = require("luasnip")
  local cmp = require("cmp")
  
  print("=== HTML Snippets Debug ===")
  print("Current filetype: " .. vim.bo.filetype)
  print("Buffer number: " .. vim.api.nvim_get_current_buf())
  
  -- Check if LuaSnip is loaded
  local snippets = luasnip.get_snippets("html")
  if snippets and #snippets > 0 then
    print("HTML snippets loaded: " .. #snippets .. " snippets")
    print("Available snippets:")
    for i, snippet in ipairs(snippets) do
      if i <= 10 then -- Show first 10 snippets
        print("  - " .. snippet.trigger)
      end
    end
    if #snippets > 10 then
      print("  ... and " .. (#snippets - 10) .. " more")
    end
  else
    print("No HTML snippets found!")
  end
  
  -- Check CMP sources
  print("\nCMP sources:")
  local sources = cmp.get_config().sources
  if sources then
    for _, source_group in ipairs(sources) do
      for _, source in ipairs(source_group) do
        print("  - " .. source.name)
      end
    end
  end
  
  -- Check friendly-snippets
  print("\nFriendly-snippets status:")
  local vscode_loader = require("luasnip.loaders.from_vscode")
  if vscode_loader then
    print("  VSCode loader available: Yes")
  else
    print("  VSCode loader available: No")
  end
end

-- Add debug keymap
vim.keymap.set('n', '<leader>hd', debug_html_snippets, { 
  buffer = true, 
  desc = "Debug HTML snippets" 
})

print("HTML ftplugin loaded - use <leader>hd to debug snippets")