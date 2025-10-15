--[[
╭─────────────────────────────────────────────────────────────╮
│                    Color Swatch Plugin                     │
│                                                             │
│  Real-time color highlighting for CSS, SCSS, HTML, JS     │
│  Shows color previews as background highlights             │
╰─────────────────────────────────────────────────────────────╯
--]]

return {
  -- Color highlighter plugin
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>uc", "<cmd>ColorizerToggle<cr>", desc = "Toggle Colorizer (Buffer)" },
      { "<leader>uC", "<cmd>ColorizerAttachToBuffer<cr>", desc = "Attach Colorizer to Buffer" },
    },
    opts = {
      filetypes = {
        "css",
        "scss",
        "sass",
        "html",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "json",
        "yaml",
        "toml",
        "lua",
        "vim",
        -- Enable for configuration files that might contain colors
        "conf",
        "config",
      },
      user_default_options = {
        -- Color formats to recognize and highlight
        RGB = true,         -- #RGB hex codes (3 digit)
        RRGGBB = true,      -- #RRGGBB hex codes (6 digit)
        names = true,       -- "Name" codes like Blue, red, etc.
        RRGGBBAA = true,    -- #RRGGBBAA hex codes (8 digit with alpha)
        AARRGGBB = false,   -- 0xAARRGGBB hex codes (not common in CSS)
        rgb_fn = true,      -- CSS rgb() and rgba() functions
        hsl_fn = true,      -- CSS hsl() and hsla() functions
        css = true,         -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true,      -- Enable all CSS *functions*: rgb_fn, hsl_fn
        
        -- Display mode for color highlighting
        mode = "background", -- Set the display mode: 'foreground', 'background', 'virtualtext'
        
        -- Additional options
        tailwind = false,    -- Enable tailwind colors (set to true if you use Tailwind CSS)
        sass = {             -- Enable sass colors
          enable = true,
          parsers = { "css" }, -- Use CSS parser for SASS files
        },
        virtualtext = "■",   -- Character to use for virtualtext mode
        
        -- Performance and behavior options
        always_update = false, -- Update color values even if buffer is not focused
      },
      
      -- Buffer-local options to override global settings
      buftypes = {},
    },
    config = function(_, opts)
      require("colorizer").setup(opts)
      
      -- Auto-attach to supported file types when opening
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        group = vim.api.nvim_create_augroup("ColorizerAutoAttach", { clear = true }),
        pattern = { "*.css", "*.scss", "*.sass", "*.html", "*.js", "*.ts", "*.jsx", "*.tsx", "*.vue" },
        callback = function()
          require("colorizer").attach_to_buffer(0)
        end,
      })
      
      -- Create user commands for easier control
      vim.api.nvim_create_user_command("ColorizerEnable", function()
        require("colorizer").attach_to_buffer(0)
        vim.notify("Colorizer enabled for current buffer", vim.log.levels.INFO)
      end, { desc = "Enable colorizer for current buffer" })
      
      vim.api.nvim_create_user_command("ColorizerDisable", function()
        require("colorizer").detach_from_buffer(0)
        vim.notify("Colorizer disabled for current buffer", vim.log.levels.INFO)
      end, { desc = "Disable colorizer for current buffer" })
      
      vim.api.nvim_create_user_command("ColorizerReload", function()
        require("colorizer").reload_all_buffers()
        vim.notify("Colorizer reloaded for all buffers", vim.log.levels.INFO)
      end, { desc = "Reload colorizer for all buffers" })
    end,
  },
}