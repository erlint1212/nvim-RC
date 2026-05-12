# NordVim

**A batteries-included Neovim configuration built for speed, ergonomics, and the Norwegian keyboard.**

NordVim is a fully configured Neovim development environment that combines powerful IDE features — LSP, autocompletion, AI-assisted coding, project-wide search-and-replace — with first-class support for the Nordic keyboard layout, so you never have to fight your own hardware to use Vim motions.

<!-- ![Insert Screenshot or GIF here] -->

## Motivation

If you've ever tried to use Vim on a Norwegian keyboard, you know the pain. Keys like `[`, `]`, `{`, `}`, `$`, and `~` are buried behind multi-key combos that shatter any sense of flow. Most Neovim configs are built by and for US-layout users and simply don't address this.

I needed a setup that solved three problems at once:

1. **The Nordic keyboard tax.** Characters essential to Vim motions (`[]{}$~`) require `AltGr` or `Shift+AltGr` on a Norwegian layout. NordVim remaps `ø`, `æ`, `Ø`, `Æ`, `¤`, and `¨` to their Vim equivalents, giving you the same fluency as a US-layout user — without switching your OS keymap.
2. **Tool sprawl.** I was tired of stitching together LSP, formatting, linting, git integration, snippets, and an AI assistant from scratch every time I set up a new machine. NordVim bundles everything behind [lazy.nvim](https://github.com/folke/lazy.nvim) so the full stack installs in one shot.
3. **Local-first AI.** Cloud-based copilots leak context and cost money. NordVim ships with [CodeCompanion](https://github.com/olimorris/codecompanion.nvim) pre-configured against a **local Ollama** instance (Qwen 2.5 Coder 14B), giving you inline completions, chat, and even automatic conventional commit messages — all offline.

## Quick Start

### fedora workstation (gnome)

```bash
sudo dnf install gcc make git
```

```bash
sudo dnf install ripgrep fd-find wl-clipboard
```

```bash
sudo dnf install nodejs npm python3 python3-pip
```

```bash
sudo dnf install okular latexmk texlive-scheme-medium
```

```bash
sudo dnf install tmux
```

```bash
sudo dnf install unzip gzip tar curl wget python3 python3-pip python3-virtualenv nodejs npm golang rust cargo java-latest-openjdk
```

```bash
sudo dnf install unzip gzip tar curl wget
```


### nixos

**Prerequisites:** Neovim **≥ 0.9**, Git, and a [Nerd Font](https://www.nerdfonts.com/) installed in your terminal.

1. **Back up your existing config** (if any):

   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. **Clone the repo:**

   ```bash
   git clone https://github.com/erlint1212/nvim-RC.git ~/.config/nvim
   ```

3. **Launch Neovim:**

   ```bash
   nvim
   ```

   On first launch, **lazy.nvim** will bootstrap itself and install every plugin automatically. Mason will then fetch the configured LSP servers, formatters, and linters. Give it a minute, restart Neovim, and you're ready.

4. *(Optional)* **Enable AI features** — install [Ollama](https://ollama.com) and pull the default model:

   ```bash
   ollama pull qwen2.5-coder:14b-instruct-q4_k_m
   ```

## Usage

### Plugin Stack

| Category | Plugin | What It Does |
|---|---|---|
| **Plugin Manager** | lazy.nvim | Declarative, lazy-loading plugin management |
| **Fuzzy Finder** | Telescope | File search, grep, git file navigation |
| **File Bookmarks** | Harpoon | Instant switching between pinned files |
| **Syntax** | Treesitter | Structural highlighting for 16+ languages |
| **LSP** | lsp-zero + Mason | Zero-config language servers with auto-install |
| **Autocompletion** | nvim-cmp | Completions from LSP, snippets, paths, and buffers |
| **Snippets** | LuaSnip + friendly-snippets | VS Code-compatible snippet library |
| **Formatting** | conform.nvim | Per-language auto-format on demand or project-wide |
| **Linting** | nvim-lint | On-save diagnostics for Go and Python |
| **Diagnostics List** | trouble.nvim | Pretty list for diagnostics, references, and the quickfix |
| **Tool Installer** | mason-tool-installer | Auto-installs formatters and linters via Mason |
| **Git** | Fugitive + Gitsigns | Status, blame, diffs, and sign-column indicators |
| **Search & Replace** | Spectre | Project-wide find-and-replace with live preview |
| **AI Assistant** | CodeCompanion + Ollama | Local LLM chat, inline edits, and commit generation |
| **Pairs & Surround** | nvim-autopairs + nvim-surround | Auto-close brackets and edit surrounding pairs (`ysiw)`) |
| **Indent Guides** | indent-blankline | Visual indentation lines |
| **Notifications** | fidget.nvim | Pretty LSP progress notifications |
| **Theme** | Rosé Pine | Elegant, low-contrast colorscheme |
| **Statusline** | Lualine | Informative bar showing mode, branch, diagnostics |
| **LaTeX** | VimTeX | Compilation, forward/inverse search with Okular |

### Key Bindings

*Leader key:* **`Space`**

#### Navigation & Editing

| Binding | Mode | Action |
|---|---|---|
| `<leader>pv` | Normal | Open file explorer (netrw) |
| `<leader>pf` | Normal | Find files (Telescope) |
| `<C-p>` | Normal | Find git-tracked files |
| `<leader>ps` | Normal | Grep across project |
| `<leader>a` | Normal | Add file to Harpoon |
| `<C-e>` | Normal | Toggle Harpoon quick menu |
| `<leader>1` … `<leader>4` | Normal | Jump to Harpoon slot 1–4 |
| `J` / `K` | Visual | Move selected block down / up |
| `H` / `L` | Normal | Jump to first / last non-blank character |
| `<C-d>` / `<C-u>` | Normal | Half-page scroll (auto-centers cursor) |
| `n` / `N` | Normal | Next / previous search match (auto-centers) |
| `<A-e>` | Any | Alternative to `<Esc>` (easier reach) |
| `<leader>u` | Normal | Toggle Undotree |
| `<leader>x` | Normal | Make current file executable |
| `<leader>D` | Normal / Visual | Delete line contents, keep indent, enter insert |
| `<leader>y` / `<leader>Y` | Normal / Visual | Yank to system clipboard |
| `<leader>d` | Normal / Visual | Delete without copying to register |
| `<leader>p` | Visual | Paste without overwriting clipboard |
| `<leader>se` / `<leader>sd` | Normal | Enable / disable English spell check |

#### Norwegian Keyboard Remaps

| Key | Maps To | Vim Meaning |
|---|---|---|
| `ø` | `[` | Previous (motions, diagnostics) |
| `æ` | `]` | Next (motions, diagnostics) |
| `Ø` | `{` | Paragraph backward |
| `Æ` | `}` | Paragraph forward |
| `¤` | `$` | End of line |
| `¨` | `~` | Toggle case |
| `,` | `/` | Search forward |

#### LSP

| Binding | Mode | Action |
|---|---|---|
| `gd` | Normal | Go to definition |
| `K` | Normal | Hover documentation |
| `<leader>vws` | Normal | Workspace symbol search |
| `<leader>vd` | Normal | Show diagnostic float |
| `<leader>vca` | Normal | Code actions |
| `<leader>vrr` | Normal | Find all references |
| `<leader>vrn` | Normal | Rename symbol |
| `[d` / `]d` | Normal | Next / previous diagnostic |
| `<C-h>` | Insert | Signature help |

#### Diagnostics & Lists

| Binding | Mode | Action |
|---|---|---|
| `<leader>xx` | Normal | Toggle buffer diagnostics (Trouble) |
| `<leader>xq` | Normal | Toggle quickfix list (Trouble) |
| `<leader>xw` | Normal | Workspace diagnostics (Telescope picker) |
| `<leader>l` | Normal | Manually trigger linting on current file |

#### Git

| Binding | Mode | Action |
|---|---|---|
| `<leader>gs` | Normal | Open Fugitive git status |
| `<leader>gm` | Normal | Generate AI commit message |

#### Formatting & Search

| Binding | Mode | Action |
|---|---|---|
| `<leader>f` | Any | Format current buffer |
| `:FormatProject` | Command | Format every tracked file in the repo |
| `<leader>S` | Normal | Toggle Spectre (project search/replace) |
| `<leader>sw` | Normal / Visual | Search current word or selection |

#### AI (CodeCompanion)

| Binding | Mode | Action |
|---|---|---|
| `<leader>ch` | Normal / Visual | Open CodeCompanion actions |
| `<leader>ci` | Normal | Inline AI prompt |
| `<leader>ca` | Visual | AI actions on selection |

#### Snippet Shortcuts

| Binding | Mode | Action |
|---|---|---|
| `<leader>ee` | Normal | Insert Go `if err != nil` error-handling block |
| `<leader>pi` | Normal | Insert standard Python data-science imports (pandas, seaborn, numpy, matplotlib) |

### Formatting Configuration

Conform auto-formatters are configured per filetype:

- **Lua** → `stylua`
- **Python** → `ruff`
- **JavaScript / TypeScript** → `prettierd` (fallback: `prettier`)
- **Go** → `goimports` + `gofmt`
- **SQL** → `sqlfluff` (Snowflake dialect, dbt templater)
- **LaTeX** → `latexindent`
- **YAML / CSS / HTML** → `prettier`
- **Kotlin** → `ktlint`
- **Nix** → `nixfmt`

### Linting Configuration

nvim-lint runs automatically on `BufEnter`, `BufWritePost`, and `InsertLeave`:

- **Go** → `golangcilint`
- **Python** → `ruff`

### Treesitter Parsers

Parsers are pre-configured for: **Nix, Python, GDScript, JavaScript, TypeScript, C, Lua, Vim, VimDoc, Go, Rust, CSS, Templ, Dockerfile, HTML, and Kotlin.**

### Directory Structure

```
~/.config/nvim/
├── init.lua                 # Entry point — loads the Erling module
├── lua/Erling/
│   ├── init.lua             # Bootstraps lazy, remaps, and settings
│   ├── lazy.lua             # Plugin declarations + lazy.nvim bootstrap
│   ├── remap.lua            # Global keymaps & Norwegian layout fixes
│   ├── set.lua              # Vim options (line numbers, tabs, scroll)
│   └── latex.lua            # VimTeX / Okular configuration
├── after/plugin/            # Per-plugin configuration (loaded after plugins)
│   ├── telescope.lua
│   ├── lsp.lua
│   ├── treesitter.lua
│   ├── lint.lua
│   ├── trouble.lua
│   ├── harpoon.lua
│   ├── undotree.lua
│   ├── conform.lua
│   ├── codecompanion.lua
│   ├── gitsigns.lua
│   ├── fugitive.lua
│   ├── spectre.lua
│   ├── lualine.lua
│   └── colors.lua
└── spell/                   # Spell files for English and Norwegian (Bokmål)
```

## Contributing

Contributions, bug reports, and feature suggestions are welcome.

### Local Setup

1. **Fork and clone** the repository:

   ```bash
   git clone https://github.com/erlint1212/nvim-RC.git
   cd nordvim
   ```

2. **Create a symlink** to test without overwriting your main config:

   ```bash
   NVIM_APPNAME=nordvim-dev ln -s "$(pwd)" ~/.config/nvim-RC-dev
   ```

   Then launch with:

   ```bash
   NVIM_APPNAME=nordvim-dev nvim
   ```

3. **Make your changes**, then verify:
   - All plugins install cleanly (`:Lazy sync`)
   - LSP servers start without errors (`:LspInfo`)
   - Formatting runs correctly (`<leader>f` on a test file)
   - Linting fires on save for Go and Python files
   - Treesitter parsers are healthy (`:TSInstallInfo`)

4. **Open a pull request** with a clear description of *what* changed and *why*.
