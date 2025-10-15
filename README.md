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
- **Colorizer** for real-time color swatch previews in CSS, SCSS, HTML, and JavaScript files

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

### File Creation & Management

| Key          | Action               | Description                                          |
| ------------ | -------------------- | ---------------------------------------------------- |
| `<leader>fn` | New file             | Create new file (saves to current working directory) |
| `<leader>vn` | New vertical split   | Create new file in vertical split                    |
| `<leader>vh` | New horizontal split | Create new file in horizontal split                  |
| `<leader>vf` | Find file in h-split | Find/create file in horizontal split                 |
| `<leader>vF` | Find file in v-split | Find/create file in vertical split                   |

### Window & Buffer Management

| Key          | Action              | Description                              |
| ------------ | ------------------- | ---------------------------------------- |
| `<leader>bd` | Delete buffer       | Delete current buffer (with save prompt) |
| `<leader>bD` | Force delete buffer | Force delete buffer (no save prompt)     |
| `<leader>vq` | Close window        | Close current window                     |
| `<leader>vc` | Close window        | Close current window (alternative)       |
| `<leader>vo` | Close other windows | Close all windows except current         |
| `<leader>vx` | Exchange windows    | Exchange current window with next        |
| `<leader>vr` | Rotate windows      | Rotate windows clockwise                 |
| `<leader>vR` | Rotate windows      | Rotate windows counter-clockwise         |
| `<leader>v=` | Equalize windows    | Make all windows equal size              |
| `<leader>qq` | Quit all            | Quit Neovim (all buffers)                |

### Window Layouts & Splits

| Key          | Action           | Description                 |
| ------------ | ---------------- | --------------------------- |
| `<leader>vs` | Horizontal split | Split window horizontally   |
| `<leader>vv` | Vertical split   | Split window vertically     |
| `<leader>-`  | Split below      | Split window below          |
| `<leader>\|` | Split right      | Split window right          |
| `<leader>v2` | 2-column layout  | Create 2-column layout      |
| `<leader>v3` | 3-column layout  | Create 3-column layout      |
| `<leader>v4` | 4-window grid    | Create 4-window grid layout |

### Window Resizing

| Key          | Action          | Description                 |
| ------------ | --------------- | --------------------------- |
| `<leader>v+` | Increase height | Increase window height by 5 |
| `<leader>v-` | Decrease height | Decrease window height by 5 |
| `<leader>v>` | Increase width  | Increase window width by 5  |
| `<leader>v<` | Decrease width  | Decrease window width by 5  |

### Window Movement

| Key          | Action            | Description              |
| ------------ | ----------------- | ------------------------ |
| `<leader>vH` | Move window left  | Move window to far left  |
| `<leader>vJ` | Move window down  | Move window to far down  |
| `<leader>vK` | Move window up    | Move window to far up    |
| `<leader>vL` | Move window right | Move window to far right |

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

### UI & Visual

| Key          | Action           | Description                    |
| ------------ | ---------------- | ------------------------------ |
| `<leader>uc` | Toggle colorizer | Toggle color swatches (buffer) |
| `<leader>uC` | Attach colorizer | Attach colorizer to buffer     |

## 🔧 Configuration Structure

```
nvim/
├── init.lua                 # Main entry point
├── lua/
│   ├── config/             # Core configuration
│   │   ├── autocmds.lua    # Auto commands
│   │   ├── keymaps.lua     # Key mappings
│   │   ├── lazy.lua        # Plugin manager setup
│   │   └── options.lua     # Neovim options
│   └── plugins/            # Plugin configurations
│       ├── alpha.lua       # Dashboard
│       ├── colorizer.lua   # Color swatch previews
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
4. **Test Colorizer**: Open a CSS file to see color swatches automatically appear

### Color Swatch Features

1. **Automatic Detection**: Color swatches appear automatically in CSS, SCSS, HTML, and JavaScript files
2. **Supported Formats**:
   - Hex colors: `#ff0000`, `#f00`, `#ff000080`
   - RGB/RGBA: `rgb(255, 0, 0)`, `rgba(255, 0, 0, 0.5)`
   - HSL/HSLA: `hsl(0, 100%, 50%)`, `hsla(0, 100%, 50%, 0.5)`
   - Named colors: `red`, `blue`, `transparent`
   - CSS variables: `var(--primary-color)`
3. **Toggle Control**: Use `<leader>uc` to toggle colorizer on/off per buffer
4. **Commands Available**:
   - `:ColorizerEnable` - Enable for current buffer
   - `:ColorizerDisable` - Disable for current buffer
   - `:ColorizerReload` - Reload all buffers

### Workflow Tips

1. **Use the Dashboard**: Press `<leader>` on startup to see available actions
2. **Explore with Which-key**: Press `<leader>` and wait to see available keybindings
3. **Search Everything**: Use `<leader>ff` for files, `<leader>/` for text
4. **Git Workflow**: Use `<leader>gg` for a full Git interface
5. **Code Navigation**: Use `gd`, `gr`, and `K` for LSP features

### File Creation & Management Workflow

1. **Creating New Files**:

   - Use `<leader>fn` to create a new file in the current working directory
   - Use `<leader>vn` or `<leader>vh` to create files in splits for side-by-side editing
   - Files are saved to the current working directory (check with `:pwd`)

2. **File Management**:

   - Save new files with `<leader>w` or `<C-s>` (will prompt for filename)
   - Use `<leader>wq` to save and quit, or `<leader>qq` to quit all
   - Close windows with `<leader>vq` or `<leader>vc`

3. **Buffer Deletion (File Removal)**:

   - Use `<leader>bd` to delete current buffer (prompts to save if modified)
   - Use `<leader>bD` to force delete buffer without saving
   - **Note**: These commands remove the file from Neovim's memory, not from disk
   - To delete files from disk, use Neo-tree (`<leader>e`) and right-click → delete

4. **Neo-tree File Management**:

   - Use `<leader>e` to toggle Neo-tree file explorer
   - Use `<leader>E` to open Neo-tree in floating window
   - **File Operations in Neo-tree:**
     - `a` - Create new file/directory (end with `/` for directory)
     - `d` - Delete file/directory
     - `r` - Rename file/directory
     - `c` - Copy file/directory
     - `x` - Cut file/directory
     - `p` - Paste file/directory
     - `y` - Copy file/directory name to clipboard
     - `Y` - Copy file/directory path to clipboard
   - **Navigation:**
     - `Enter` or `o` - Open file/expand directory
     - `<C-s>` - Open file in horizontal split
     - `<C-v>` - Open file in vertical split
     - `<C-t>` - Open file in new tab
     - `P` - Preview file (toggle)
     - `l` - Open file/expand directory
     - `h` - Close directory/go to parent
     - `.` - Toggle hidden files
     - `/` - Search in current directory
     - `f` - Filter files
     - `F` - Clear filter
     - `R` - Refresh tree
     - `?` - Show help

5. **Window Management**:

   - Create layouts quickly with `<leader>v2`, `<leader>v3`, or `<leader>v4`
   - Use `<leader>vo` to focus on one file (close all other windows)
   - Resize windows with `<leader>v+/-/>/<` for precise control

6. **Working Directory**:
   - Files created with `<leader>fn` save to the current working directory
   - Check current directory with `:pwd`
   - Change directory with `:cd /path/to/directory` if needed

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

#### Neo-tree Issues

**Neo-tree not opening with `<leader>e`:**

1. **Check if Neo-tree is installed:**

   ```vim
   :Lazy
   ```

   Look for "neo-tree.nvim" in the plugin list

2. **Force install Neo-tree:**

   ```vim
   :Lazy sync
   ```

3. **Test the command directly:**

   ```vim
   :Neotree toggle
   ```

4. **Check dependencies:**
   Ensure these plugins are installed:

   - `plenary.nvim`
   - `nvim-web-devicons`
   - `nui.nvim`

5. **Force load the plugin:**
   ```vim
   :Lazy load neo-tree.nvim
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
- **Neo-tree Not Working**: **RESOLVED** - Fixed plugin installation issue with `:Lazy sync`
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
