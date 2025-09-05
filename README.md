# 🚀 Neovim Configuration 2025

A comprehensive, modern Neovim configuration designed for web development with PHP, JavaScript, CSS, SCSS, and Twig support.

## ✨ Features

### 🎨 **Theme & UI**

- **Tokyo Night** theme with multiple variants (night, storm, moon, day)
- **Alpha** dashboard with beautiful startup screen
- **Lualine** statusline with Git integration and diagnostics
- **Neo-tree** file explorer with Git status
- **Which-key** for keybinding discovery

### 🔧 **Language Support**

- **LSP** servers for:
  - PHP (Intelephense)
  - JavaScript/TypeScript (tsserver, eslint)
  - CSS/SCSS (cssls)
  - HTML with Twig support (HTML LSP handles .twig files)
  - JSON, YAML, Lua
- **Treesitter** syntax highlighting (currently disabled)
  - Note: Temporarily disabled due to query compatibility issues with Neovim 0.10.0
  - All files use built-in syntax highlighting (still fully functional with LSP)
  - Can be re-enabled once parsers are updated for compatibility
- **Mason** for automatic LSP server installation

### 🤖 **AI Integration**

- **GitHub Copilot** with inline suggestions
- **CopilotChat** for interactive AI assistance
- Smart code completion and generation

### 🔍 **Search & Navigation**

- **Telescope** fuzzy finder with FZF integration
- **FZF** native integration for better performance
- Advanced file, text, and symbol search
- Git integration (branches, commits, status)

### 📝 **Code Editing**

- **LuaSnip** with custom snippets for PHP, JavaScript, and more
- **nvim-cmp** intelligent autocompletion
- **Treesitter** text objects and incremental selection
- **Auto-pairs** and smart indentation

### 🔄 **Git Integration**

- **Neogit** modern Git interface
- **Diffview** for better diff viewing
- **Gitsigns** for inline Git status
- Git blame, hunks, and staging support

### 🛠 **Development Tools**

- **Trouble** for diagnostics and quickfix
- **Illuminate** for highlighting word occurrences
- **Indent guides** and scope visualization
- **Auto-formatting** on save
- **Persistence** for automatic session management

## 📦 Installation

### Prerequisites

Make sure you have the following installed:

- **Neovim** >= 0.9.0
- **Git**
- **Node.js** >= 18.x (for Copilot and LSP servers)
- **ripgrep** (for Telescope search)
- **fd** (optional, for better file finding)
- **make** (for building FZF native extension)

### Quick Install

1. **Backup your existing config** (if any):

   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this configuration**:

   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. **Start Neovim**:

   ```bash
   nvim
   ```

4. **Wait for plugins to install** - Lazy.nvim will automatically install all plugins on first run.

5. **Install LSP servers**:
   - Open Neovim and run `:Mason`
   - All required servers should install automatically
   - Or manually install with `:MasonInstall <server-name>`

## 🎯 Key Mappings

### General

| Key           | Action            | Description          |
| ------------- | ----------------- | -------------------- |
| `<Space>`     | Leader key        | Main leader key      |
| `<C-h/j/k/l>` | Window navigation | Move between windows |
| `<S-h/l>`     | Buffer navigation | Previous/next buffer |
| `<leader>qq`  | Quit              | Quit all             |

### File Operations

| Key          | Action                | Description              |
| ------------ | --------------------- | ------------------------ |
| `<leader>e`  | File explorer         | Toggle Neo-tree          |
| `<leader>E`  | File explorer (float) | Toggle Neo-tree in float |
| `<leader>ff` | Find files            | Telescope file finder    |
| `<leader>fg` | Git files             | Find Git files           |
| `<leader>fr` | Recent files          | Recently opened files    |

### Search

| Key          | Action        | Description              |
| ------------ | ------------- | ------------------------ |
| `<leader>/`  | Live grep     | Search in files          |
| `<leader>sw` | Search word   | Search word under cursor |
| `<leader>sb` | Search buffer | Search in current buffer |
| `<leader>sh` | Help tags     | Search help              |

### Git

| Key          | Action         | Description        |
| ------------ | -------------- | ------------------ |
| `<leader>gg` | Neogit         | Open Git interface |
| `<leader>gc` | Git commit     | Quick commit       |
| `<leader>gd` | Git diff       | Open diff view     |
| `<leader>gs` | Git status     | Git status         |
| `]h` / `[h`  | Next/prev hunk | Navigate Git hunks |

### Session Management

| Key          | Action          | Description          |
| ------------ | --------------- | -------------------- |
| `<leader>qs` | Restore session | Load current session |
| `<leader>qS` | Select session  | Choose from sessions |
| `<leader>ql` | Last session    | Restore last session |
| `<leader>qd` | Don't save      | Skip saving session  |

### LSP

| Key          | Action           | Description        |
| ------------ | ---------------- | ------------------ |
| `gd`         | Go to definition | Jump to definition |
| `gr`         | Go to references | Find references    |
| `K`          | Hover            | Show documentation |
| `<leader>ca` | Code action      | Show code actions  |
| `<leader>rn` | Rename           | Rename symbol      |

### Copilot

| Key           | Action              | Description                 |
| ------------- | ------------------- | --------------------------- |
| `<M-l>`       | Accept suggestion   | Accept Copilot suggestion   |
| `<M-]>`       | Next suggestion     | Next Copilot suggestion     |
| `<M-[>`       | Previous suggestion | Previous Copilot suggestion |
| `<leader>cci` | Copilot chat        | Ask Copilot                 |
| `<leader>cce` | Explain code        | Explain selected code       |

### Snippets

| Key       | Action      | Description                       |
| --------- | ----------- | --------------------------------- |
| `<Tab>`   | Expand/jump | Expand snippet or jump to next    |
| `<S-Tab>` | Jump back   | Jump to previous snippet position |

### Write/Save

| Key          | Action        | Description        |
| ------------ | ------------- | ------------------ |
| `<leader>w`  | Save file     | Write current file |
| `<leader>wa` | Save all      | Write all files    |
| `<leader>wq` | Save and quit | Write and quit     |
| `<leader>ww` | Save file     | Write current file |

### Tabs

| Key                  | Action       | Description        |
| -------------------- | ------------ | ------------------ |
| `<leader><tab>l`     | Last tab     | Go to last tab     |
| `<leader><tab>f`     | First tab    | Go to first tab    |
| `<leader><tab><tab>` | New tab      | Create new tab     |
| `<leader><tab>]`     | Next tab     | Go to next tab     |
| `<leader><tab>d`     | Close tab    | Close current tab  |
| `<leader><tab>[`     | Previous tab | Go to previous tab |

## 🔧 Configuration Structure

```
nvim_2025/
├── init.lua                 # Main entry point
├── lua/
│   ├── config/             # Core configuration
│   │   ├── autocmds.lua    # Auto commands
│   │   ├── keymaps.lua     # Key mappings
│   │   ├── lazy.lua        # Plugin manager setup
│   │   └── options.lua     # Neovim options
│   └── plugins/            # Plugin configurations
│       ├── alpha.lua       # Dashboard
│       ├── colorscheme.lua # Tokyo Night theme
│       ├── copilot.lua     # GitHub Copilot
│       ├── editor.lua      # Editor enhancements
│       ├── lsp.lua         # Language servers
│       ├── lualine.lua     # Statusline
│       ├── neogit.lua      # Git interface
│       ├── snippets.lua    # Code snippets
│       ├── telescope.lua   # Fuzzy finder
│       └── treesitter.lua  # Syntax highlighting
├── snippets/               # Custom snippets
│   ├── javascript.lua      # JS snippets
│   └── php.lua            # PHP snippets
└── README.md              # This file
```

## 🎨 Customization

### Changing Theme Variant

Edit `lua/plugins/colorscheme.lua`:

```lua
opts = {
  style = "night", -- storm, moon, night, day
  -- ... other options
}
```

### Adding Custom Snippets

Create files in the `snippets/` directory:

```lua
-- snippets/html.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("div", {
    t("<div>"),
    i(1),
    t("</div>"),
  }),
}
```

### Adding New LSP Servers

Edit `lua/plugins/lsp.lua` and add to the `servers` table:

```lua
servers = {
  -- existing servers...
  your_server = {
    settings = {
      -- server-specific settings
    }
  },
}
```

## 🚀 Usage Tips

### First Time Setup

1. **Install Copilot**: Run `:Copilot auth` to authenticate with GitHub
2. **Check Health**: Run `:checkhealth` to ensure everything is working
3. **Update Plugins**: Run `:Lazy update` to get the latest versions

### Workflow Tips

1. **Use the Dashboard**: Press `<leader>` on startup to see available actions
2. **Explore with Which-key**: Press `<leader>` and wait to see available keybindings
3. **Search Everything**: Use `<leader>ff` for files, `<leader>/` for text
4. **Git Workflow**: Use `<leader>gg` for a full Git interface
5. **Code Navigation**: Use `gd`, `gr`, and `K` for LSP features

### Troubleshooting

#### LSP Not Working

```bash
:LspInfo          # Check LSP status
:Mason            # Install/update servers
:checkhealth lsp  # Diagnose issues
```

#### Copilot Issues

**Authentication Error (401 status)**:
If you see "Not authenticated: Failed to get copilot token due to 401 status", run:

```bash
:Copilot auth     # Authenticate with GitHub
```

Follow the prompts to authenticate with your GitHub account that has Copilot access.

**Other Copilot Commands**:

```bash
:Copilot status   # Check Copilot status
:Copilot signout  # Sign out and re-authenticate
:Copilot disable  # Disable Copilot
:Copilot enable   # Enable Copilot
```

**Note**: The current configuration uses `zbirenbaum/copilot.lua` which handles authentication automatically. If authentication fails, try restarting Neovim and running `:Copilot auth` again.

#### Plugin Issues

```bash
:Lazy             # Open plugin manager
:Lazy clean       # Remove unused plugins
:Lazy update      # Update all plugins
```

#### Treesitter Errors

If you encounter Treesitter query errors:

```bash
:TSUpdate         # Update all parsers
:TSInstall <lang> # Install specific parser
:checkhealth treesitter # Check Treesitter health
```

#### Common Issues Fixed

- **Fillchars Error**: Fixed Unicode character issues in options
- **Treesitter Query Error**: **RESOLVED** - Treesitter completely disabled (`enabled = false`) due to compatibility issues with Neovim 0.10.0
- **ESLint LSP Error**: **RESOLVED** - Removed ESLint from LSP servers list (ESLint is a linter, not an LSP server)
- **Which-key Warnings**: **RESOLVED** - Updated to new API format and fixed keymap conflicts
- **Persistence Module Error**: **RESOLVED** - Added persistence.nvim plugin for session management
- **Mason-lspconfig Enable Error**: **RESOLVED** - Rewrote LSP setup to avoid automatic_enable compatibility issues
- **TSServer Deprecation**: **RESOLVED** - Updated from deprecated `tsserver` to `ts_ls`
- **Copilot Authentication Error**: **USER ACTION REQUIRED** - Run `:Copilot auth` to authenticate with GitHub
- **PHP File Errors**: All file types now work without errors after disabling Treesitter
- **Indent-blankline Error**: Replaced with mini.indentscope for better compatibility

#### Current Status - All File Types Working

- **All files** (PHP, JS, CSS, SCSS, Twig) work perfectly without errors
- **LSP functionality** fully operational for all languages (Intelephense, tsserver, cssls, etc.)
- **Built-in syntax highlighting** used instead of Treesitter (still provides good highlighting)
- **All LSP features** work: go to definition, hover, completion, diagnostics, formatting, etc.
- **No more query errors** when opening files or using Telescope

#### Re-enabling Treesitter (Future)

To re-enable Treesitter when compatibility issues are resolved:

1. Edit `lua/plugins/treesitter.lua`
2. Change `enabled = false` to `enabled = true`
3. Restart Neovim and run `:TSUpdate`

## 📚 Learning Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Lua Guide for Neovim](https://github.com/nanotee/nvim-lua-guide)
- [Tokyo Night Theme](https://github.com/folke/tokyonight.nvim)
- [Telescope Usage](https://github.com/nvim-telescope/telescope.nvim)
- [LSP Configuration](https://github.com/neovim/nvim-lspconfig)

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This configuration is open source and available under the [MIT License](LICENSE).

---

**Happy coding! 🎉**
