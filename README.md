# vimrc

Vim/Neovim configs with spacemacs-style `<Space>` keymaps, in two flavors:

- **`full.vim`**: the development setup with plugins, auto-completion and language servers.
  Targets **Neovim 0.11+** (tested on 0.12.6); still loads in classic Vim, minus the LSP/completion part.
- **`minimal.vim`**: a single plugin-free file for servers, containers and quick edits.
  Works in any Vim or Neovim with nothing else installed.

## Files

| File | Purpose |
|---|---|
| `full.vim` | Full config: plugins (vim-plug), settings and keymaps |
| `lua/config/lsp.lua` | Used by `full.vim` on Neovim: auto-completion (nvim-cmp + LuaSnip) and language servers (built-in LSP) |
| `minimal.vim` | Plugin-free config in one file; see [minimal.vim](#minimalvim) |
| `LearnVim.md` | Vim notes and a short tutorial (Chinese) |

## Install

1. **Prerequisites**

    ```bash
    # Ubuntu
    sudo apt install neovim git curl ripgrep universal-ctags jq xclip
    pip install flake8 autopep8 isort       # Python lint/fix (used by ALE)

    # Language servers for completion / go-to-definition (needs Node.js)
    npm install -g pyright bash-language-server
    sudo apt install clangd                 # optional, C/C++
    ```

    Ubuntu's `neovim` package may lag behind. For the latest release, unpack the
    official build from <https://github.com/neovim/neovim/releases> into
    `~/.local/nvim-<version>` and link `~/.local/bin/nvim` (and `vim`) to its `bin/nvim`.

2. **Clone and link** (back up any existing `~/.vimrc`, `~/.vim` and `~/.config/nvim` first)

    ```bash
    git clone git@github.com:LarryX/vimrc.git ~/repo/vimrc
    mkdir -p ~/.vim
    ln -s ~/repo/vimrc/full.vim ~/.vimrc             # Vim
    ln -s ~/.vimrc ~/.vim/init.vim                   # Neovim reads ~/.vim via the next link
    ln -s ~/.vim ~/.config/nvim
    ln -s ~/repo/vimrc/lua ~/.vim/lua                # Lua modules (required for completion/LSP)
    ```

    For the plugin-free setup, see [minimal.vim](#minimalvim) instead.

    Upgrading from the old file names (`vimrc-dev`, `vimrc-server`)? Re-point the link:
    `ln -sfn ~/repo/vimrc/full.vim ~/.vimrc`

3. **Start `nvim`.** vim-plug installs itself and the plugins on first run.
   Afterwards use `:PlugUpdate` to update and `:PlugClean` to remove unused plugins.

Check the setup with `:checkhealth`.

## Features

- **Fuzzy finding** (fzf.vim + ripgrep): files, buffers, recent files, lines, tags, commands, keymaps, with preview
- **Auto-completion** (Neovim): language server, snippet, path and buffer-word suggestions as you type
- **Code navigation** (Neovim): go to definition, hover docs, references, rename, code actions via the built-in LSP
- **Linting/fixing** (ALE): flake8 and shellcheck; `<leader>af` runs fixers (trailing whitespace, autopep8, isort, jq)
- **Git**: change signs in the gutter (gitgutter), status/diff/blame/log (fugitive)
- **Editing**: surround, multiple cursors, expand selection, auto-close brackets, comment toggling, alignment
- **Comfort**: persistent undo, restores cursor position and folds, creates missing directories on save,
  `:w!!` saves as root, Chinese encoding detection

## Keymaps (full.vim)

`<leader>` is `<Space>`. Search every mapping with `<leader>sk`.

### Files and buffers
| Key | Action |
|---|---|
| `<leader>ff` | Find file in the current directory |
| `<leader>fg` | Find git-tracked file |
| `<leader>fr` | Recent files |
| `<leader>fb`, `<leader>bb` | Open buffers |
| `<leader>fe` | Find file in the current buffer's directory |
| `<leader>ft`, `F2` | Toggle file tree (NERDTree) |
| `<leader>fl` | Reveal the current file in the tree |
| `<leader>bn` / `<leader>bp`, `]b` / `[b` | Next / previous buffer |
| `<leader>b1`…`<leader>b0`, `Ngb` | Go to buffer N |
| `<leader>b<Tab>` | Previous buffer |
| `<leader>bd` / `<leader>ba` | Close buffer / close all buffers |
| `<leader>bh` | Start screen (Startify) |
| `<leader>cd` | Change directory to the current file's folder |

### Search and replace
| Key | Action |
|---|---|
| `<leader>sg` | Live ripgrep in the project |
| `,wr` | Ripgrep the word under the cursor |
| `<leader>sw` | Grep the word / selection into the quickfix list |
| `<leader>ss` | `:Search` (grep with your own arguments) |
| `<leader>sl` / `<leader>sL` | Search lines in this buffer / all buffers |
| `<leader>st` / `<leader>sT` | Tags in this buffer / project |
| `<leader>sc` | Commands |
| `<leader>sr` / `<leader>sR` | Replace the word / selection in the file (with / without confirm) |
| `<leader>h` | Highlight the word / selection without jumping |
| `*` / `#` (visual) | Search for the selected text |
| `<leader><CR>` | Clear search highlighting |
| `]q` / `[q` | Next / previous quickfix item |
| `<leader>q` / `<leader>l` | Toggle quickfix / location list |

### Code (Neovim, when a language server is attached)
| Key | Action |
|---|---|
| `gd` / `gD` | Go to definition / declaration |
| `K` | Hover documentation |
| `grr` | References |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<C-]>` | Jump to definition (falls back to ctags) |
| `<C-j>` / `<C-k>` | Next / previous ALE problem |
| `<leader>af` | Run ALE fixers |
| `F3` | Toggle the tag outline (Tagbar) |

### Completion (insert mode, Neovim)
| Key | Action |
|---|---|
| `Tab` / `Shift-Tab` | Next / previous item; expand a snippet or jump to its next field |
| `Enter` | Accept the selected item |
| `Ctrl-Space` / `Ctrl-e` | Open / close the menu |
| `Ctrl-b` / `Ctrl-f` | Scroll documentation |

Language-server diagnostics are hidden by default because ALE already lints;
set `let g:lsp_diagnostics = 1` to show them too.

### Git
| Key | Action |
|---|---|
| `<leader>gs` | Status (`:Git`) |
| `<leader>gd` | Diff split |
| `<leader>gb` | Blame |
| `<leader>gl` | Log of the current file |
| `]h` / `[h`, `]c` / `[c` | Next / previous changed hunk |

### Windows and movement
| Key | Action |
|---|---|
| `<leader>wh/wj/wk/wl` | Move to the left/down/up/right window |
| `<leader>ws` / `<leader>wv` | Split horizontally / vertically |
| `<leader>wc` / `<leader>wo` / `<leader>w=` | Close / only this window / equalize sizes |
| `<leader>jl` / `<leader>jw` | Jump to a line / word (EasyMotion) |
| `j` / `k` | Move by screen line (counts like `5j` still use real lines) |
| `H` / `L` | Start / end of line |
| `,z` | Close all folds except the current one |
| `<leader>tt` | Open a terminal (`Esc` returns to normal mode) |

### Editing
| Key | Action |
|---|---|
| `<leader>yy` / `<leader>dd` | Yank / delete to the system clipboard |
| `<leader>pp` / `<leader>pP` | Paste from the clipboard after / before |
| `<leader>p0` | Paste the last yank (not the last delete) |
| `<C-n>` | Multiple cursors on the word under the cursor |
| `v` / `-` (visual) | Expand / shrink the selection |
| `<` / `>` (visual) | Indent and keep the selection |
| `ys`, `cs`, `ds` | Add / change / delete surroundings (vim-surround) |
| `<leader>cc`, `<leader>c<Space>` | Comment / toggle comment (NERDCommenter) |
| `<leader>t2` / `<leader>t4` | Indent width 2 / 4 |
| `<leader>=` | Format the buffer as JSON |
| `<leader>db` / `<leader>dm` | Delete trailing whitespace / `^M` |
| `<leader>tl` | Toggle showing tabs and trailing spaces |
| `:w!!` | Save as root |

### Insert mode
| Key | Action |
|---|---|
| `<C-d><C-d>` | Insert the date (YYYY-MM-DD) |
| `<C-t><C-t>` | Insert the time (HH:MM) |
| `<C-c><C-c>` | Calculate an expression and insert the result |

### Help and config
| Key | Action |
|---|---|
| `<leader>hh`, `F1` | Toggle help |
| `<leader>sk` | Search keymaps |
| `<leader>ev` / `<leader>sv` | Edit / reload the vimrc |

## Differences from default Vim keys (full.vim)

These mappings replace or delay built-in behavior:

- `H` / `L` go to line start/end (default: top/bottom of the screen); `p` leaves the cursor after the pasted text.
- `,` waits briefly because it starts several mappings.
- In visual mode, `v` expands and `-` shrinks the selection (`<C-v>` still switches to block selection).
- In insert mode, `<C-d>`, `<C-t>` and `<C-c>` wait briefly because the date/time/calculator mappings start with them.
- On the command line, `<C-a>`/`<C-b>`/`<C-f>` move like emacs (start / left / right).
- In a terminal window, `Esc` switches to normal mode; use `<C-c>` to cancel fzf.

## minimal.vim

One file, no plugins, nothing to install: copy it to any machine.

```bash
# from a clone
ln -s ~/repo/vimrc/minimal.vim ~/.vimrc
# or on a machine without the repo
curl -fLo ~/.vimrc https://raw.githubusercontent.com/LarryX/vimrc/master/minimal.vim
```

It sets line numbers, current-line highlight, smart-case incremental search, 4-space indent,
indent-based folding (all open), CJK encoding detection, the `desert` colors and an informative
status line. It returns to the last cursor position, adds a `#!` line to new `.sh`/`.py` files,
and strips trailing spaces on save in code files.

Shared with `full.vim`: `<Space>` leader, clipboard keys (`<leader>yy/dd/pp/pP/p0`), search and
replace helpers (`<leader>sr/sR/sw/ss/h`, visual `*`/`#`), `<leader>=` JSON format,
`<leader>db`/`<leader>dm`, and the insert-mode date/time/calculator keys.

Specific to `minimal.vim`:

| Key | Action |
|---|---|
| `<C-h/j/k/l>` | Move between windows |
| `F2` / `F3` / `F4` / `F5` / `F6` | Toggle line numbers / invisible characters / wrap / paste mode / syntax |
| `<leader>zz` | Close / open all folds |
| `n` `N` `*` `#` | Search and keep the match centered |
| `'` and `` ` `` | Swapped: `'a` jumps to the exact column of mark `a` |
| `<C-a>` / `<C-e>` (command line) | Start / end of line |
| `:w!!` | Save as root via `sudo tee` (classic Vim only) |

Grep uses ripgrep, then ag, then plain grep, whichever is installed.

## Plugins (full.vim)

Navigation: nerdtree, fzf + fzf.vim, vim-easymotion, vim-startify, ListToggle ·
Editing: vim-surround, vim-repeat, vim-visual-multi, vim-expand-region, delimitMate, tabular,
vim-indent-object, nerdcommenter, fencview, suda.vim ·
Completion (Neovim): nvim-cmp, cmp-nvim-lsp, cmp-buffer, cmp-path, LuaSnip, cmp_luasnip, vim-snippets ·
UI: vim-airline, gruvbox · Development: ale, tagbar, vim-fugitive, vim-gitgutter ·
Languages: vim-markdown, vim-markdown-toc, goyo.vim, SimpylFold

`:PlugStatus` lists what is installed.

See [LearnVim.md](LearnVim.md) for Vim notes and a short tutorial.
