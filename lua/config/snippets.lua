-- Custom snippet loader configuration
local M = {}

function M.setup()
  local luasnip = require("luasnip")
  
  -- Load custom snippets from the snippets directory
  local snippet_path = vim.fn.stdpath("config") .. "/snippets"
  
  local loaded_snippets = {}
  
  -- Load HTML snippets
  local html_snippets_ok, html_snippets = pcall(dofile, snippet_path .. "/html.lua")
  if html_snippets_ok and html_snippets then
    luasnip.add_snippets("html", html_snippets)
    luasnip.add_snippets("htm", html_snippets)
    table.insert(loaded_snippets, "HTML")
  end
  
  -- Load PHP snippets
  local php_snippets_ok, php_snippets = pcall(dofile, snippet_path .. "/php.lua")
  if php_snippets_ok and php_snippets then
    luasnip.add_snippets("php", php_snippets)
    table.insert(loaded_snippets, "PHP")
  end
  
  -- Load JavaScript snippets
  local js_snippets_ok, js_snippets = pcall(dofile, snippet_path .. "/javascript.lua")
  if js_snippets_ok and js_snippets then
    luasnip.add_snippets("javascript", js_snippets)
    luasnip.add_snippets("javascriptreact", js_snippets)
    luasnip.add_snippets("typescript", js_snippets)
    luasnip.add_snippets("typescriptreact", js_snippets)
    table.insert(loaded_snippets, "JavaScript")
  end
  
  -- Load HTML snippets for Twig files too (since Twig often contains HTML)
  if html_snippets_ok and html_snippets then
    luasnip.add_snippets("twig", html_snippets)
    luasnip.add_snippets("html.twig", html_snippets)
  end
  
  -- Load PHP snippets for Twig files too (since Twig often contains PHP-like syntax)
  if php_snippets_ok and php_snippets then
    luasnip.add_snippets("twig", php_snippets)
    luasnip.add_snippets("html.twig", php_snippets)
  end
  
  -- Single summary message instead of multiple individual messages
  if #loaded_snippets > 0 then
    vim.notify(string.format("[SNIPPETS] Loaded: %s", table.concat(loaded_snippets, ", ")), vim.log.levels.INFO)
  end
  
  -- Enable snippet expansion in insert mode
  vim.keymap.set({"i", "s"}, "<C-l>", function()
    if luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    end
  end, {silent = true, desc = "Expand or jump to next snippet placeholder"})
  
  vim.keymap.set({"i", "s"}, "<C-h>", function()
    if luasnip.locally_jumpable(-1) then
      luasnip.jump(-1)
    end
  end, {silent = true, desc = "Jump to previous snippet placeholder"})
end

return M