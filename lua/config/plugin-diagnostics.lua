--[[
╭─────────────────────────────────────────────────────────────╮
│                    Plugin Loading Diagnostics              │
│                                                             │
│  Comprehensive diagnostics for plugin loading issues       │
╰─────────────────────────────────────────────────────────────╯
--]]

local M = {}

-- Function to diagnose plugin loading issues
function M.diagnose_plugins()
  local lazy_ok, lazy = pcall(require, "lazy")
  if not lazy_ok then
    vim.notify("[PLUGIN DIAG ERROR] Lazy.nvim not available", vim.log.levels.ERROR)
    return
  end

  local stats = lazy.stats()
  local plugins = lazy.plugins()
  
  print("=== PLUGIN LOADING DIAGNOSTICS ===")
  print(string.format("Total plugins configured: %d", #plugins))
  print(string.format("Loaded plugins: %d", stats.loaded))
  print(string.format("Startup time: %.2fms", stats.startuptime))
  print("")
  
  -- Categorize plugins by status
  local loaded = {}
  local not_loaded = {}
  local failed = {}
  
  for name, plugin in pairs(plugins) do
    if plugin._.loaded then
      table.insert(loaded, name)
    elseif plugin._.loaded == false then
      table.insert(not_loaded, name)
    else
      table.insert(failed, name)
    end
  end
  
  print("=== LOADED PLUGINS ===")
  for _, name in ipairs(loaded) do
    print("✓ " .. name)
  end
  
  print("\n=== NOT LOADED PLUGINS ===")
  for _, name in ipairs(not_loaded) do
    local plugin = plugins[name]
    local reason = "Unknown"
    
    if plugin.lazy then
      reason = "Lazy loaded (waiting for trigger)"
    elseif plugin.enabled == false then
      reason = "Disabled"
    elseif plugin.cond == false then
      reason = "Condition not met"
    elseif plugin._.dep then
      reason = "Dependency issue"
    end
    
    print("✗ " .. name .. " (" .. reason .. ")")
  end
  
  print("\n=== FAILED PLUGINS ===")
  for _, name in ipairs(failed) do
    print("⚠ " .. name)
  end
  
  -- Check for common issues
  print("\n=== COMMON ISSUES CHECK ===")
  
  -- Check for dependency conflicts
  local dep_issues = {}
  for name, plugin in pairs(plugins) do
    if plugin.dependencies then
      for _, dep in ipairs(plugin.dependencies) do
        local dep_name = type(dep) == "string" and dep or dep[1]
        if not plugins[dep_name] or not plugins[dep_name]._.loaded then
          table.insert(dep_issues, string.format("%s requires %s", name, dep_name))
        end
      end
    end
  end
  
  if #dep_issues > 0 then
    print("Dependency issues found:")
    for _, issue in ipairs(dep_issues) do
      print("  - " .. issue)
    end
  else
    print("No dependency issues found")
  end
  
  -- Check for configuration errors
  print("\n=== CONFIGURATION ERRORS ===")
  local config_errors = {}
  
  for name, plugin in pairs(plugins) do
    if plugin._.error then
      table.insert(config_errors, string.format("%s: %s", name, plugin._.error))
    end
  end
  
  if #config_errors > 0 then
    for _, error in ipairs(config_errors) do
      print("ERROR: " .. error)
    end
  else
    print("No configuration errors found")
  end
end

-- Function to force load all plugins (for debugging)
function M.force_load_all()
  local lazy_ok, lazy = pcall(require, "lazy")
  if not lazy_ok then
    vim.notify("[PLUGIN DIAG ERROR] Lazy.nvim not available", vim.log.levels.ERROR)
    return
  end

  print("=== FORCE LOADING ALL PLUGINS ===")
  local plugins = lazy.plugins()
  local loaded_count = 0
  local failed_count = 0
  
  for name, plugin in pairs(plugins) do
    if not plugin._.loaded then
      print("Attempting to load: " .. name)
      local success, error_msg = pcall(function()
        lazy.load({ plugins = { name } })
      end)
      
      if success then
        print("✓ Successfully loaded: " .. name)
        loaded_count = loaded_count + 1
      else
        print("✗ Failed to load " .. name .. ": " .. tostring(error_msg))
        failed_count = failed_count + 1
      end
    end
  end
  
  print(string.format("\nForce load results: %d loaded, %d failed", loaded_count, failed_count))
end

-- Function to check plugin file structure
function M.check_plugin_files()
  print("=== PLUGIN FILE STRUCTURE CHECK ===")
  
  local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
  local files = vim.fn.glob(plugin_dir .. "/*.lua", false, true)
  
  print("Plugin files found:")
  for _, file in ipairs(files) do
    local filename = vim.fn.fnamemodify(file, ":t")
    print("  " .. filename)
    
    -- Try to load the file and check for syntax errors
    local success, result = pcall(function()
      return dofile(file)
    end)
    
    if success then
      if type(result) == "table" then
        local plugin_count = 0
        if result[1] then
          -- Array of plugins
          plugin_count = #result
        else
          -- Single plugin or named plugins
          plugin_count = 1
        end
        print("    ✓ Valid Lua file with " .. plugin_count .. " plugin(s)")
      else
        print("    ⚠ File doesn't return a table")
      end
    else
      print("    ✗ Syntax error: " .. tostring(result))
    end
  end
end

-- Function to validate lazy.nvim configuration
function M.validate_lazy_config()
  print("=== LAZY.NVIM CONFIGURATION VALIDATION ===")
  
  local config_file = vim.fn.stdpath("config") .. "/lua/config/lazy.lua"
  if vim.fn.filereadable(config_file) == 1 then
    print("✓ lazy.lua config file exists")
    
    local success, config = pcall(dofile, config_file)
    if success then
      print("✓ lazy.lua config file loads without errors")
    else
      print("✗ lazy.lua config file has errors: " .. tostring(config))
    end
  else
    print("✗ lazy.lua config file not found")
  end
  
  -- Check if lazy.nvim is properly installed
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if vim.fn.isdirectory(lazypath) == 1 then
    print("✓ lazy.nvim is installed")
  else
    print("✗ lazy.nvim is not installed")
  end
end

-- Main diagnostic function
function M.run_full_diagnostics()
  print("Starting comprehensive plugin diagnostics...\n")
  
  M.validate_lazy_config()
  print("")
  
  M.check_plugin_files()
  print("")
  
  M.diagnose_plugins()
  print("")
  
  print("=== RECOMMENDATIONS ===")
  local lazy_ok, lazy = pcall(require, "lazy")
  if lazy_ok then
    local stats = lazy.stats()
    if stats.loaded < 10 then
      print("- Very few plugins loaded. Check for:")
      print("  * Dependency conflicts")
      print("  * Configuration errors")
      print("  * Lazy loading conditions")
    end
    
    if stats.startuptime > 100 then
      print("- Slow startup time. Consider:")
      print("  * Enabling lazy loading for more plugins")
      print("  * Removing unused plugins")
    end
  end
  
  print("\nDiagnostics complete. Run :lua require('config.plugin-diagnostics').force_load_all() to attempt loading all plugins.")
end

return M