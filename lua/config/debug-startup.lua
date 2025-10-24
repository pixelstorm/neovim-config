--[[
╭─────────────────────────────────────────────────────────────╮
│                    Startup Debug Logging                   │
│                                                             │
│  Diagnostic logging to identify plugin loading bottlenecks │
╰─────────────────────────────────────────────────────────────╯
--]]

local M = {}

-- Track plugin loading times
local plugin_times = {}
local startup_time = vim.loop.hrtime()

-- Log function with timestamp
local function log_with_time(message, level)
  local current_time = vim.loop.hrtime()
  local elapsed_ms = (current_time - startup_time) / 1000000
  local timestamp = string.format("[%6.2fms]", elapsed_ms)
  vim.notify(timestamp .. " " .. message, level or vim.log.levels.INFO)
end

-- Hook into lazy.nvim loading
local function setup_lazy_hooks()
  local lazy_ok, lazy = pcall(require, "lazy")
  if not lazy_ok then
    log_with_time("❌ Lazy.nvim not available for hooking", vim.log.levels.ERROR)
    return
  end

  -- Hook into plugin loading events
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",
    callback = function(event)
      local plugin_name = event.data
      local current_time = vim.loop.hrtime()
      plugin_times[plugin_name] = {
        start = current_time,
        name = plugin_name
      }
      log_with_time("🔄 Loading plugin: " .. plugin_name, vim.log.levels.INFO)
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    callback = function(event)
      local plugin_name = event.data
      if plugin_times[plugin_name] then
        local current_time = vim.loop.hrtime()
        local load_time = (current_time - plugin_times[plugin_name].start) / 1000000
        log_with_time(string.format("✅ Loaded plugin: %s (%.2fms)", plugin_name, load_time), vim.log.levels.INFO)
      end
    end,
  })
end

-- Track LSP server startup times
local function setup_lsp_hooks()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client then
        log_with_time("🔗 LSP attached: " .. client.name, vim.log.levels.INFO)
      end
    end,
  })

  -- Hook into Mason installations
  local mason_ok, mason = pcall(require, "mason")
  if mason_ok then
    log_with_time("🔨 Mason available, checking installations...", vim.log.levels.INFO)
  end
end

-- Track Treesitter loading
local function setup_treesitter_hooks()
  vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate*",
    callback = function(event)
      log_with_time("🌳 Treesitter event: " .. event.match, vim.log.levels.INFO)
    end,
  })
end

-- Main setup function
function M.setup()
  log_with_time("🚀 Starting Neovim with debug logging enabled", vim.log.levels.WARN)
  
  -- Log system info
  log_with_time("📊 Neovim version: " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch, vim.log.levels.INFO)
  log_with_time("💻 OS: " .. vim.loop.os_uname().sysname, vim.log.levels.INFO)
  
  setup_lazy_hooks()
  setup_lsp_hooks()
  setup_treesitter_hooks()
  
  -- Log when VimEnter is reached
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      local total_time = (vim.loop.hrtime() - startup_time) / 1000000
      log_with_time(string.format("🎯 VimEnter reached! Total startup time: %.2fms", total_time), vim.log.levels.WARN)
      
      -- Show plugin count
      local lazy_ok, lazy = pcall(require, "lazy")
      if lazy_ok then
        local plugins = lazy.plugins()
        local loaded_count = 0
        for _, plugin in pairs(plugins) do
          if plugin._.loaded then
            loaded_count = loaded_count + 1
          end
        end
        log_with_time(string.format("📦 Plugins loaded: %d/%d", loaded_count, vim.tbl_count(plugins)), vim.log.levels.WARN)
      end
    end,
  })
  
  -- Final report after everything is loaded
  vim.defer_fn(function()
    local total_time = (vim.loop.hrtime() - startup_time) / 1000000
    log_with_time(string.format("🏁 Final startup report: %.2fms", total_time), vim.log.levels.ERROR)
  end, 1000)
end

return M