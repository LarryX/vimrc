" ============================================================================
" vimrc for develop (Vim 8+/Neovim 0.10+)
" Maintainer: AI
" Modify Date:
"       10/19/2026
" ============================================================================
" ============================================================================
" Platform
" ============================================================================
let g:system='unix'
let g:rcpath=$HOME
if has('win32')
  let g:system='windows'
  if has('nvim')
    let g:rcpath=$LOCALAPPDATA.'\nvim'
  endif
elseif has('unix')
  if has('nvim')
    let g:rcpath=$HOME.'/.local/share/nvim'
  endif
  if has('mac') || has('macunix')
    let g:system='mac'
  endif
endif

" Leader must be set before any <leader> mapping is defined
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

" ============================================================================
" Vim-plug initialization
" ============================================================================
let vim_plug_just_installed = 0
if has('nvim')
  let vim_plug = fnameescape(g:rcpath.'/site/autoload/plug.vim')
elseif g:system=='windows'
  let vim_plug = fnameescape(g:rcpath.'/vimfiles/autoload/plug.vim')
else
  let vim_plug = fnameescape(g:rcpath.'/.vim/autoload/plug.vim')
endif

if !filereadable(vim_plug)
  echo "Installing vim-plug ..."
  let result = system('curl -fLo '.vim_plug.' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  if v:shell_error
    echoerr "Error downloading vim-plug: " . result
    finish
  endif
  let vim_plug_just_installed = 1
  execute 'source '.fnameescape(vim_plug)
endif

" ============================================================================
" Active plugins
" Plugin options (g:...) must be set before the plugin loads, so they live in
" the "Plugins settings" section right below, not in a VimEnter callback.
" ============================================================================
call plug#begin('~/.vim/plugged')

" Navigation
Plug 'scrooloose/nerdtree'                      " File browser (F2, <leader>ft)
Plug 'Valloric/ListToggle'                      " Toggle quickfix/location list
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'                         " Fuzzy finder for files/buffers/lines/tags
Plug 'easymotion/vim-easymotion'
Plug 'mhinz/vim-startify'                       " Start screen with recent files

" Editing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'                         " Make '.' repeat plugin actions (surround, ...)
Plug 'mg979/vim-visual-multi'                   " Multiple cursors (<C-n>), replaces vim-multiple-cursors
Plug 'terryma/vim-expand-region'                " v/<C-v> in visual mode to grow/shrink selection
Plug 'Raimondi/delimitMate'                     " Auto-close quotes and brackets
Plug 'godlygeek/tabular'                        " Align text
Plug 'mbbill/fencview'                          " Auto-detect Chinese file encodings
Plug 'michaeljsmith/vim-indent-object'          " ii / ai indent text objects
Plug 'scrooloose/nerdcommenter'                 " Code commenter
Plug 'lambdalisue/suda.vim'                     " :w!! as root (sudo tee doesn't work in Neovim)

" Completion + snippets
Plug 'honza/vim-snippets'                       " Snippet collection (snipmate format)
if has('nvim-0.11')
  Plug 'hrsh7th/nvim-cmp'                       " Completion popup (config: "Completion & LSP" below)
  Plug 'hrsh7th/cmp-nvim-lsp'                   "   source: language servers
  Plug 'hrsh7th/cmp-buffer'                     "   source: words in open buffers
  Plug 'hrsh7th/cmp-path'                       "   source: file paths
  Plug 'L3MON4D3/LuaSnip'                       " Snippet engine, loads vim-snippets
  Plug 'saadparwaiz1/cmp_luasnip'               "   source: snippets
else
  Plug 'tomtom/tlib_vim'
  Plug 'MarcWeber/vim-addon-mw-utils'
  Plug 'garbas/vim-snipmate'
endif

" User Interface
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'

" Develop
Plug 'w0rp/ale'                                 " Async lint/fix
Plug 'majutsushi/tagbar'                        " Class/module browser (F3)
Plug 'tpope/vim-fugitive'                       " Git (:Git, :Gdiffsplit, ...)
Plug 'airblade/vim-gitgutter'                   " Git diff signs

" Languages
Plug 'plasticboy/vim-markdown'
Plug 'mzlogin/vim-markdown-toc'
Plug 'junegunn/goyo.vim', { 'for': 'markdown' } " Distraction-free writing
Plug 'tmhedberg/SimpylFold'                     " Python folding

call plug#end()

if vim_plug_just_installed
  echo "Installing Bundles, please ignore key map error messages"
  PlugInstall
endif

" ============================================================================
" Plugins settings and mappings
" ============================================================================
" ListToggle: <leader>q quickfix, <leader>l location list
let g:lt_quickfix_list_toggle_map = '<leader>q'
let g:lt_location_list_toggle_map = '<leader>l'

" NERDTree
nnoremap <silent> <F2> :NERDTreeToggle<cr>
nnoremap <silent> <leader>ft :NERDTreeToggle<cr>
nnoremap <silent> <leader>fl :NERDTreeFind<cr>
let NERDTreeShowBookmarks=1         " always show bookmarks
let NERDTreeChDirMode=2             " auto set pwd when open bookmarks
let NERDTreeIgnore=['node_modules', '__pycache__', '\.pyc$', '\.pyo$', '\~$', '\.o$']
let g:NERDTreeDirArrowExpandable  = g:system=='windows' ? '+' : '▸'
let g:NERDTreeDirArrowCollapsible = g:system=='windows' ? '~' : '▾'
augroup NerdTreeCfg
  autocmd!
  " open NERDTree when vim starts on a directory
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
  " close vim if the only window left open is a NERDTree
  autocmd BufEnter * if winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree() | q | endif
augroup END

" Tagbar
nnoremap <silent> <F3> :TagbarToggle<cr>
let g:tagbar_width     = 30
let g:tagbar_autofocus = 1

" fzf (replaces CtrlP; same <leader> keys)
" From a NERDTree window, jump to the previous window first so files open there
nnoremap <silent> <expr> <leader>ff (&filetype == 'nerdtree' ? "\<c-w>p" : '').":Files\<cr>"
nnoremap <silent> <leader>fg :GFiles<cr>
nnoremap <silent> <leader>fr :History<cr>
nnoremap <silent> <leader>fb :Buffers<cr>
nnoremap <silent> <leader>bb :Buffers<cr>
nnoremap <silent> <leader>fe :Files <C-r>=expand("%:p:h")<cr><cr>
nnoremap <leader>fj :e .<cr>
nnoremap <silent> <leader>st :BTags<cr>
nnoremap <silent> ,g :BTags<cr>
nnoremap <silent> <leader>sT :Tags<cr>
nnoremap <silent> ,G :Tags<cr>
nnoremap <silent> <leader>sl :BLines<cr>
nnoremap <silent> ,f :BLines<cr>
nnoremap <silent> <leader>sL :Lines<cr>
nnoremap <silent> <leader>sc :Commands<cr>
nnoremap <silent> ,c :Commands<cr>
nnoremap <silent> <leader>sk :Maps<cr>
" ripgrep the project (live): <leader>sg, or the word under cursor: ,wr
nnoremap <silent> <leader>sg :Rg<cr>
nnoremap <silent> ,wr :Rg <C-r><C-w><cr>
nnoremap <silent> ,wf :BLines <C-r><C-w><cr>
nnoremap <silent> ,wg :BTags <C-r><C-w><cr>
nnoremap <silent> ,we :call fzf#vim#files('', fzf#vim#with_preview({'options': ['--query', expand('<cword>')]}))<cr>
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
let g:fzf_preview_window = ['right,50%', 'ctrl-/']
" Files: list with rg (respects .gitignore, includes dotfiles, skips .git)
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git"'
endif

" Startify
nnoremap <silent> <leader>bh :Startify<cr>
let g:startify_change_to_vcs_root = 1

" GitGutter
let g:gitgutter_max_signs = 2000
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" Fugitive
nnoremap <silent> <leader>gs :Git<cr>
nnoremap <silent> <leader>gd :Gdiffsplit<cr>
nnoremap <silent> <leader>gb :Git blame<cr>
nnoremap <silent> <leader>gl :Git log --oneline -- %<cr>

" EasyMotion
map  <leader>jl <Plug>(easymotion-bd-jk)
nmap <leader>jl <Plug>(easymotion-overwin-line)
map  <leader>jw <Plug>(easymotion-bd-w)
nmap <leader>jw <Plug>(easymotion-overwin-w)
let g:EasyMotion_smartcase = 1

" Expand region
xmap v <Plug>(expand_region_expand)
xmap <C-v> <Plug>(expand_region_shrink)

" delimitMate
let delimitMate_quotes = "\" ' `"
augroup DelimitMateCfg
  autocmd!
  autocmd FileType python,vim let b:delimitMate_quotes = "' `"
  autocmd FileType markdown let b:delimitMate_quotes = "\" '"
augroup END

" suda: :w!! writes the file as root
let g:suda_smart_edit = 0
cnoreabbrev <expr> w!! (getcmdtype() == ':' && getcmdline() ==# 'w!!') ? 'SudaWrite' : 'w!!'

" ALE
let g:ale_linters = {
      \   'python': ['flake8'],
      \   'sh': ['shellcheck'],
      \   }
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \   'python': ['autopep8', 'isort'],
      \   'json': ['jq'],
      \   }
let g:ale_python_flake8_options = '--ignore=E501'
let g:ale_sign_column_always = 1
let g:ale_sign_error = '>'
let g:ale_sign_warning = '-'
let g:ale_lint_on_text_changed = 'normal'       " lint after edits in normal mode, not every keystroke
let g:ale_lint_on_insert_leave = 1
let g:ale_echo_msg_format = '[%linter%] %s'
let g:airline#extensions#ale#enabled = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nnoremap <silent> <leader>af :ALEFix<cr>

" NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

" SimpylFold
let g:SimpylFold_docstring_preview = 1

" vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_frontmatter = 1

" snipmate (plain Vim only)
let g:snipMate = { 'snippet_version' : 1 }

" ============================================================================
" Completion & LSP (Neovim 0.11+)
"   Insert mode: <Tab>/<S-Tab> next/prev item (or jump in a snippet),
"   <CR> accept the selected item, <C-Space> open menu, <C-e> close.
"   Normal mode (when a language server is attached):
"   gd definition, K hover docs, grr references, <leader>rn rename, <leader>ca code action.
"   Servers: pyright (python), bash-language-server (sh), clangd (c/c++) if installed.
"   Diagnostics stay with ALE; set g:lsp_diagnostics = 1 to also show the servers'.
" ============================================================================
if has('nvim-0.11')
  " ~/repo/vimrc/lua/config/lsp.lua (linked as ~/.vim/lua)
  lua require('config.lsp')
endif

" airline
let g:airline#extensions#tabline#enabled = 1    " show buffers on top; jump with 1gb, 2gb, ...
let g:airline#extensions#tabline#buffer_nr_show = 1

" ============================================================================
" General
" ============================================================================
filetype plugin indent on
syntax on

if g:system=="windows"
  set fileformats=dos,unix,mac
else
  set fileformats=unix,dos,mac
endif
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese
set formatoptions+=mB                 " break/join CJK text without adding spaces
set ambiwidth=single
set nrformats=                        " <C-a>/<C-x> treat numbers as decimal
set autoread
set hidden
set updatetime=300                    " faster CursorHold/gitgutter refresh (default 4s)
set timeoutlen=500                    " mapping timeout
set ttimeoutlen=10                    " snappy <Esc>
set wildignore+=*.o,*~,*.so,*.swp,*.zip,*.pyc,*_build/*,*/.git/*,*/.hg/*,*/.svn/*,*/tmp/*

" Persistent undo, backups and swap kept out of the working directory
if has('nvim')
  set undofile                        " stored under ~/.local/state/nvim/undo
else
  for s:d in ['tmp', 'backups', 'undos']
    if !isdirectory(expand('~/.vim/dirs/'.s:d)) | call mkdir(expand('~/.vim/dirs/'.s:d), 'p') | endif
  endfor
  set noswapfile
  set directory=~/.vim/dirs/tmp
  set backup
  set backupdir=~/.vim/dirs/backups
  set undofile
  set undodir=~/.vim/dirs/undos
  set viminfo+=n~/.vim/dirs/viminfo
  set viminfo^=%
endif

augroup GeneralCfg
  autocmd!
  " Return to last edit position when opening files
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~# 'commit' | exe "normal! g`\"" | endif
  " Save/restore folds per file (normal files only)
  autocmd BufWinLeave * if &buftype ==# '' && expand('%') !=# '' | silent! mkview | endif
  autocmd BufWinEnter * if &buftype ==# '' && expand('%') !=# '' | silent! loadview | endif
  " Create missing parent directories on save (replaces auto_mkdir)
  autocmd BufWritePre * if &buftype ==# '' && !isdirectory(expand('<afile>:p:h')) | call mkdir(expand('<afile>:p:h'), 'p') | endif
  " Turn off paste mode when leaving insert mode
  autocmd InsertLeave * set nopaste
  " Re-check for outside changes when focusing vim
  autocmd FocusGained,BufEnter * silent! checktime
augroup END
set viewoptions=folds,cursor          " don't save cwd/options in views

" ============================================================================
" User Interface
" ============================================================================
set number
set ruler
set scrolloff=7
set laststatus=2
set signcolumn=yes                    " keep text from shifting when signs appear
set wildmenu
set wildmode=longest:full,full
set completeopt=menuone,noselect      " built-in <C-n> menu (nvim-cmp sets its own)
set shortmess-=S                      " show [n/m] search count (replaces IndexedSearch)
set incsearch
set hlsearch
set ignorecase
set smartcase
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set lazyredraw
set showmatch
set matchtime=2
set noerrorbells
set novisualbell
set linebreak
set wrap
set breakindent                       " wrapped lines keep the indent
set autoindent                        " filetype indent rules do the rest
set cinoptions=g0
set splitbelow
set splitright
if has('nvim')
  set inccommand=split                " live preview of :s substitutions
endif

if has('termguicolors') && ($COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit' || has('nvim'))
  set termguicolors
endif
set background=dark
let g:gruvbox_contrast_dark = 'medium'
silent! colorscheme gruvbox

if has('gui_running')
  if has("mac") || has("macunix")
    set guifont=Monaco\ for\ Powerline:h13
  elseif g:system=='windows'
    set guifont=Monaco\ for\ Powerline:h14:cANSI
    set renderoptions=type:directx,renmode:5
  endif
  set guioptions-=T guioptions-=r guioptions-=L
  set linespace=2
  set lines=40 columns=160
endif

set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set list
set listchars=tab:\|\ ,trail:·,nbsp:␣
nnoremap <leader>tl :set list!<cr>

augroup FileTypeCfg
  autocmd!
  autocmd BufNewFile,BufRead *.spacemacs setf lisp
  autocmd FileType vim,json,html,xhtml,xml,css,htmldjango,yaml,vue,javascript,typescript,lua,toml setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType make setlocal noexpandtab
  autocmd FileType gitcommit setlocal spell spelllang=en_us,cjk
augroup END

" Keep sign column and spell highlights readable
hi! link SignColumn LineNr
highlight clear SpellBad
highlight SpellBad term=underline cterm=underline gui=undercurl
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline

set foldenable
set foldmethod=syntax
set foldlevel=20

" ============================================================================
" Mapping
" F1 - help; F2 - file(nerdtree); F3 - tag(tagbar)
" ============================================================================
function! ToggleHelp()
  for w in range(1, winnr('$'))
    if getbufvar(winbufnr(w), '&buftype') ==# 'help'
      helpclose
      return
    endif
  endfor
  help
endfunction
nnoremap <silent> <F1> :call ToggleHelp()<cr>
nnoremap <silent> <leader>hh :call ToggleHelp()<cr>

nnoremap t2 :setlocal ts=2 sts=2 sw=2 expandtab<cr>
nnoremap t4 :setlocal ts=4 sts=4 sw=4 expandtab<cr>

" Edit / reload this config
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>:echo "vimrc reloaded"<cr>

" Command line: emacs-style movement
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>

" Neovim terminal
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  augroup TermCfg
    autocmd!
    autocmd TermOpen * setlocal nonumber signcolumn=no | startinsert
    autocmd BufEnter term://* startinsert
  augroup END
  nnoremap <silent> <leader>tt :botright split \| resize 15 \| terminal<cr>
endif

" ---------------------------------------
" Buffers
" ---------------------------------------
nnoremap <leader>bn :bnext<cr>
nnoremap <leader>bp :bprevious<cr>
nnoremap ]b :bnext<cr>
nnoremap [b :bprevious<cr>
for s:i in range(1, 9)
  execute 'nnoremap <leader>b'.s:i.' :'.s:i.'b<cr>'
endfor
nnoremap <leader>b0 :10b<cr>
nnoremap <leader>bd :bdelete<cr>
nnoremap <leader>ba :%bdelete!<cr>
nnoremap <leader>b<tab> :b#<cr>
" Ngb jumps to buffer number N
nnoremap <silent> gb :<C-u>execute (v:count ? v:count.'b' : 'bnext')<cr>
nnoremap <leader>cd :cd %:p:h<cr>:pwd<cr>
set switchbuf=useopen,usetab
set showtabline=2

" ---------------------------------------
" Windows / moving
" ---------------------------------------
" j/k move by screen line, but 5j etc. still count real lines
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
xnoremap <expr> j v:count ? 'j' : 'gj'
xnoremap <expr> k v:count ? 'k' : 'gk'
nnoremap H ^
nnoremap L $
xnoremap H ^
xnoremap L g_
nnoremap <leader>wj <C-W>j
nnoremap <leader>wk <C-W>k
nnoremap <leader>wh <C-W>h
nnoremap <leader>wl <C-W>l
nnoremap <leader>ws :split<cr>
nnoremap <leader>wv :vsplit<cr>
nnoremap <leader>wc :close<cr>
nnoremap <leader>wo :only<cr>
nnoremap <leader>w= <C-W>=

" ---------------------------------------
" Folding
" ---------------------------------------
nnoremap zO zCzO
nnoremap ,z zMzv

" ---------------------------------------
" Edit
" ---------------------------------------
" System clipboard
nnoremap <leader>yy "+yy
xnoremap <leader>yy "+y
nnoremap <leader>dd "+dd
xnoremap <leader>dd "+d
nnoremap <leader>pp "+p
xnoremap <leader>pp "+p
nnoremap <leader>pP "+P
xnoremap <leader>pP "+P
" Paste the last yank (not the last delete)
nnoremap <leader>p0 "0p
xnoremap <leader>p0 "0p

" Keep selection when indenting
xnoremap < <gv
xnoremap > >gv
" Y yanks to end of line (like D, C)
nnoremap Y y$

" Format JSON in buffer
nnoremap <leader>= :%!python3 -m json.tool --indent 2<cr>

" Delete trailing whitespace / Windows ^M
function! DeleteTrailingWS()
  let l:view = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:view)
endfunction
nnoremap <silent> <leader>db :call DeleteTrailingWS()<cr>
nnoremap <silent> <leader>dm :let _v=winsaveview()<cr>:keeppatterns %s/\r$//e<cr>:call winrestview(_v)<cr>
augroup TrimWS
  autocmd!
  autocmd BufWritePre *.py,*.sh,*.c,*.cpp,*.h,*.hpp,*.cu call DeleteTrailingWS()
augroup END

" Insert date / time / calculation
inoremap <silent> <C-D><C-D> <C-R>=strftime("%Y-%m-%d")<cr>
inoremap <silent> <C-T><C-T> <C-R>=strftime("%H:%M")<cr>
inoremap <silent> <C-C><C-C> <C-R>=string(eval(input("Calculate: ")))<cr>

" Keep cursor at end of yanked/pasted text
xnoremap <silent> y y`]
xnoremap <silent> p p`]
nnoremap <silent> p p`]

" ---------------------------------------
" Search, grep
" ---------------------------------------
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --glob\ '!.git'
  set grepformat=%f:%l:%c:%m
elseif executable('ag')
  set grepprg=ag\ --vimgrep
  set grepformat=%f:%l:%c:%m
else
  set grepprg=grep\ -nrI\ --exclude-dir={.git,.hg,.svn}
endif

nnoremap <silent> <leader><cr> :nohlsearch<cr>

" Visual * / #: search for the selected text (http://vim.wikia.com/wiki/VimTip171)
let s:save_cpo = &cpo | set cpo&vim
if !exists('g:VeryLiteral')
  let g:VeryLiteral = 0
endif
function! s:VSetSearch(cmd)
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  normal! gvy
  if @@ =~? '^[0-9a-z,_]*$' || @@ =~? '^[0-9a-z ,_]*$' && g:VeryLiteral
    let @/ = @@
  else
    let pat = escape(@@, a:cmd.'\')
    if g:VeryLiteral
      let pat = substitute(pat, '\n', '\\n', 'g')
    else
      let pat = substitute(pat, '^\_s\+', '\\s\\+', '')
      let pat = substitute(pat, '\_s\+$', '\\s\\*', '')
      let pat = substitute(pat, '\_s\+', '\\_s\\+', 'g')
    endif
    let @/ = '\V'.pat
  endif
  normal! gV
  call setreg('"', old_reg, old_regtype)
endfunction
xnoremap <silent> * :<C-U>call <SID>VSetSearch('/')<cr>/<C-R>/<cr>
xnoremap <silent> # :<C-U>call <SID>VSetSearch('?')<cr>?<C-R>/<cr>
nnoremap <silent> <leader>vl :let g:VeryLiteral = !g:VeryLiteral<bar>echo "VeryLiteral " . (g:VeryLiteral ? "On" : "Off")<cr>
let &cpo = s:save_cpo | unlet s:save_cpo

" Highlight (without jumping) the word under cursor / the selection
nnoremap <silent> <leader>h :let @/='\<<C-R>=expand("<cword>")<cr>\>'<cr>:set hls<cr>
xnoremap <silent> <leader>h :<C-U>call <SID>VSetSearch('/')<cr>:set hls<cr>

" Replace the word under cursor / the selection in the whole file
xnoremap <leader>sr ""y:%s/<C-R>=escape(@", '/\')<cr>//gc<Left><Left><Left>
xnoremap <leader>sR ""y:%s/<C-R>=escape(@", '/\')<cr>//g<Left><Left>
nnoremap <leader>sr :%s/\<<C-R><C-W>\>//gc<Left><Left><Left>
nnoremap <leader>sR :%s/\<<C-R><C-W>\>//g<Left><Left>

" Grep the word under cursor / the selection into the quickfix list
nnoremap <silent> <leader>sw :silent grep! -w <C-R><C-W><cr>:cwindow<cr>:redraw!<cr>
xnoremap <silent> <leader>sw y:silent grep! -F -- <C-R>=shellescape(@")<cr><cr>:cwindow<cr>:redraw!<cr>
command! -nargs=+ -complete=file -bar Search silent! grep! <args>|cwindow|redraw!
nnoremap <leader>ss :Search<Space>

" Quickfix navigation
nnoremap ]q :cnext<cr>
nnoremap [q :cprevious<cr>

" ===============================================================================
" ctags: generate with  ctags -R --c++-kinds=+px --fields=+iaS --extras=+q .
" ===============================================================================
set tags=./tags;,tags
" <C-]> lists all matches when there is more than one
nnoremap <C-]> g<C-]>
