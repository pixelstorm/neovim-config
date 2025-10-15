-- PHP-specific configuration
-- Includes completion mappings and enhanced file navigation

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
end, { buffer = true, desc = "PHP Tab completion" })

vim.keymap.set("i", "<S-Tab>", function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.locally_jumpable(-1) then
    luasnip.jump(-1)
  end
end, { buffer = true, desc = "PHP Shift-Tab completion" })

-- Setup enhanced PHP file navigation
local php_nav_ok, php_nav = pcall(require, 'config.php-navigation')
if php_nav_ok then
  php_nav.setup()
  print("PHP navigation loaded - use gf to navigate to included files")
else
  vim.notify("Failed to load PHP navigation module", vim.log.levels.WARN)
  
  -- Fallback: basic PHP file navigation setup
  vim.opt_local.path:append("**")
  vim.opt_local.suffixesadd:prepend(".php")
  vim.opt_local.suffixesadd:prepend(".inc")
  
  print("PHP ftplugin loaded with basic navigation")
end