-- Test script to validate Twig syntax highlighting fix
-- Run this with: nvim --headless -l test_twig_fix.lua

-- Create a temporary .html.twig file
local temp_file = vim.fn.tempname() .. ".html.twig"
vim.fn.writefile({
  "{% extends 'base.html.twig' %}",
  "{% block content %}",
  "    <h1>{{ title }}</h1>",
  "    <p>{{ description|raw }}</p>",
  "    {% for item in items %}",
  "        <div class=\"item\">{{ item.name }}</div>",
  "    {% endfor %}",
  "{% endblock %}"
}, temp_file)

-- Open the file and check filetype detection
vim.cmd("edit " .. temp_file)

print("=== TWIG SYNTAX HIGHLIGHTING FIX TEST ===")
print("File: " .. temp_file)
print("Detected filetype: " .. (vim.bo.filetype or "NONE"))
print("Expected filetype: twig")
print("Filetype detection: " .. (vim.bo.filetype == "twig" and "✓ PASS" or "✗ FAIL"))

-- Check treesitter parser availability
local has_twig_parser = pcall(function()
  return vim.treesitter.language.require_language("twig")
end)
print("Twig parser available: " .. (has_twig_parser and "✓ YES" or "✗ NO"))

-- Check if treesitter is active for this buffer
local ts_active = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil
print("Treesitter highlighting active: " .. (ts_active and "✓ YES" or "✗ NO"))

print("\n=== SUMMARY ===")
local all_working = vim.bo.filetype == "twig" and has_twig_parser and ts_active
print("Twig syntax highlighting: " .. (all_working and "✅ WORKING" or "❌ NOT WORKING"))

-- Clean up
vim.fn.delete(temp_file)
vim.cmd("qa!")