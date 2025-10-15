-- Twig-specific Tab mapping to ensure completion works
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
end, { buffer = true, desc = "Twig Tab completion" })

vim.keymap.set("i", "<S-Tab>", function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.locally_jumpable(-1) then
    luasnip.jump(-1)
  end
end, { buffer = true, desc = "Twig Shift-Tab completion" })