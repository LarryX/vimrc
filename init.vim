" ============================================================================
" Maintainer: ovsoil
"       hxyumail@gmail.com
"       http://ovsoil.com
" Create Date:
"       01/09/2015
" ============================================================================
set nocompatible
" Use utf-8 if Vim was complied with multi-byte support
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
endif

if $TERM == "xterm-256color" || $COLORTERM == "gnome-terminal"
  set t_Co=256
endif

if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif
let g:python3_host_prog = '~/.pyenv/versions/neovim/bin/python3.9'

" base
set nocompatible                " don't bother with vi compatibility
set autoread                    " reload files when changed on disk, i.e. via `git checkout`
set shortmess=atI
set magic                       " For regular expressions turn magic on
set title                       " change the terminal's title
set nobackup                    " do not keep a backup file
set nowritebackup
set novisualbell                " turn off visual bell
set noerrorbells                " don't beep
set visualbell t_vb=            " turn off error beep/flash
set t_vb=
set tm=500
set history=1000                " lines of history
set cmdheight=2                 " Give more space for displaying messages.

" filetype
filetype on
filetype plugin indent on       " enable filetype plugins

"dein begin-----------------------------
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
call dein#begin('~/.cache/dein')
call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

call dein#add('lifepillar/vim-gruvbox8')

call dein#add('Shougo/defx.nvim')
if !has('nvim')
  call dein#add('roxma/nvim-yarp')
  call dein#add('roxma/vim-hug-neovim-rpc')
endif

call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 }) 
call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })

call dein#add('luochen1990/rainbow')
call dein#add('majutsushi/tagbar')
call dein#add('tpope/vim-surround')

call dein#add('airblade/vim-gitgutter')
call dein#add('APZelos/blamer.nvim')
call dein#add('preservim/nerdcommenter')

call dein#add('neoclide/coc.nvim', { 'merged': 0, 'rev': 'release' })

" plugins to try:
" grep - Ag or ripgrep
" git - tpope/vim-fugitive
" debug - vimspector
" highlight - Nvim Treesitter
" workflow -  asyncrun.vim + asynctasks.vim
" fuzzy finder - LeaderF

call dein#end()

" call map(dein#check_clean(), { _, val -> delete(val, 'rf') })
" call dein#recache_runtimepath()

"if dein#check_install()
"  call dein#install()
"endif
"dein end-------------------------

" movement
set scrolloff=7                 " keep 7 lines when scrolling

" ui
syntax on
set ruler                       " show the current row and column
set number                      " show line numbers
set wrap
set showcmd                     " show incomplete commands
set showmode                    " show current modes
set showmatch                   " jump to matches when entering parentheses
set matchtime=2                 " tenths of a second to show the matching parenthesis

" tab/indent
set expandtab                   " expand tabs to spaces
set smarttab
set autoindent smartindent shiftround
set shiftwidth=4
set tabstop=4
set softtabstop=4                " insert mode tab and backspace use 4 spaces

" search
set hlsearch                    " highlight searches
set incsearch                   " do incremental searching, search as you type
set ignorecase                  " ignore case when searching
set smartcase                   " no ignorecase if Uppercase char present

" select & complete
set selection=inclusive
set selectmode=mouse,key

set completeopt=longest,menu
set wildmenu                           " show a navigable menu for tab completion"
set wildmode=longest,list,full
set wildignore=*.o,*~,*.pyc,*.class

" others
set backspace=indent,eol,start  " make that backspace key work the way it should
set whichwrap+=<,>,h,l
" set mouse=a                   " enable basic mouse behavior such as resizing buffers.

" leader
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"


" fold
set foldenable
set foldmethod=indent
set foldlevel=99
let g:FoldMethod = 0
map <leader>zz :call ToggleFold()<cr>
fun! ToggleFold()
    if g:FoldMethod == 0
        exe "normal! zM"
        let g:FoldMethod = 1
    else
        exe "normal! zR"
        let g:FoldMethod = 0
    endif
endfun

" if this not work ,make sure .viminfo is writable for you
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" json comment highlighting
autocmd FileType json syntax match Comment +\/\/.\+$+

" ============================ theme and status line ============================
" theme
set background=dark
colorscheme gruvbox8

" set mark column color
" set cursorcolumn
set cursorline
hi! link SignColumn   LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange

" status line
set laststatus=2   " Always show the status line - use 2 lines for the status bar
set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P

" ============================ specific file type ===========================
autocmd FileType python set tabstop=4 shiftwidth=4 expandtab ai
autocmd BufRead,BufNew *.md,*.mkd,*.markdown  set filetype=markdown.mkd

autocmd BufNewFile *.sh,*.py exec ":call AutoSetFileHead()"
function! AutoSetFileHead()
    " .sh
    if &filetype == 'sh'
        call setline(1, "\#!/bin/bash")
    endif

    " python
    if &filetype == 'python'
        call setline(1, "\#!/usr/bin/env python")
        call append(1, "\# encoding: utf-8")
    endif

    normal G
    normal o
    normal o
endfunc

autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

" ============================ key map ============================
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j
nnoremap H ^
nnoremap L $

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
nmap <leader>wj <C-W>j
nmap <leader>wk <C-W>k
nmap <leader>wh <C-W>h
nmap <leader>wl <C-W>l
nmap <leader>ws :split<CR>
nmap <leader>wv :vs<CR>
nmap <leader>wc :close<CR>

au InsertLeave * set nopaste

"Keep search pattern at the center of the screen."
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" remove highlight
" noremap <silent><leader>/ :nohls<CR>
nnoremap <leader><cr> :nohl<cr>

"Reselect visual block after indent/outdent.调整缩进后自动选中，方便再次操作
vnoremap < <gv
vnoremap > >gv

" y$ -> Y Make Y behave like other capitals
map Y y$

"Map ; to : and save a million keystrokes 用于快速进入命令行
nnoremap ; :

" save
cmap w!! w !sudo tee >/dev/null %

" command mode, ctrl-a to head， ctrl-e to tail
cnoremap <C-j> <t_kd>
cnoremap <C-k> <t_ku>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

vnoremap <leader>dd "+d
nmap <leader>yy "+yy
vmap <leader>yy "+y
nmap <leader>pp "+p
vmap <leader>pp "+p
nmap <leader>pP "+P
vmap <leader>pP "+P
map <leader>p "0p
au InsertLeave * set nopaste                    " Disbale paste mode when leaving insert mode
"nmap <leader>= <Esc>:%!python -m json.tool<cr>

" Delete the blank space or Windows ^M at trail of line
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
nmap <leader>db :call DeleteTrailingWS()<cr>
nmap <leader>dm mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()
" insert some usefull text
imap <silent> <C-D><C-D> <C-R>=strftime("%e %b %Y")<cr>
imap <silent> <C-T><C-T> <C-R>=strftime("%l:%M %p")<cr>
imap <silent> <C-C><C-C> <C-R>=string(eval(input("Calculate: ")))<cr>

if executable('ag')             " The Silver Searcher
  set grepprg=ag\ --nogroup\ --nocolor
else
  set grepprg=grep\ -nrI\ --exclude-dir={CVS,'.bzr','.git','.hg','.svn'}
endif
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
vnoremap <silent> * :<C-U>call <SID>VSetSearch('/')<cr>/<C-R>/<cr>
vnoremap <silent> # :<C-U>call <SID>VSetSearch('?')<cr>?<C-R>/<cr>
vmap <kMultiply> *
nmap <silent> <Plug>VLToggle :let g:VeryLiteral = !g:VeryLiteral
      \\| echo "VeryLiteral " . (g:VeryLiteral ? "On" : "Off")<cr>
if !hasmapto("<Plug>VLToggle")
  nmap <unique> <Leader>vl <Plug>VLToggle
endif
let &cpo = s:save_cpo | unlet s:save_cpo

" highlight but not search the word at cursor
nnoremap <leader>h :let @/='\<<C-R>=expand("<cword>")<cr>\>'<cr>:set hls<cr>
" highlight but not search the selected text
vnoremap <leader>h :<C-U>call <SID>VSetSearch('/')<cr>/<C-R>/<cr>N

" replace selected text
vnoremap <leader>sr ""y:%s/<C-R>=escape(@", '/\')<cr>//gc<left><Left><Left>
vnoremap <leader>sR ""y:%s/<C-R>=escape(@", '/\')<cr>//g<Left><Left>
nnoremap <leader>sr :%s/<C-R><C-W>//gc"<left><left><left><left>
nnoremap <leader>sr :%s/<C-R><C-W>//g"<left><left><left>

" grep the word at cursor in current dir
nnoremap <leader>sw :grep! "\b<C-R><C-W>\b"<cr>:cw<cr>
vnoremap <leader>sw y:grep! '<C-R>"' .<cr>:cw<cr>

command! -nargs=+ -complete=file -bar Search silent! grep! <args>|cwindow|redraw!
nnoremap <leader>ss :Search<Space>''<left>

vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]


" keybind ----------------------------------------------------------------
" 设置 ff 为开关defx的快捷键, 其中【-search=`expand('%:p')`】表示打开defx树后，光标自动放在当前buffer上
nmap <leader>ft :Defx  -search=`expand('%:p')` -toggle <cr>
nmap <Leader>ff :Files <cr>
nmap <Leader>fp :GFiles <cr>
nmap <leader>fj :e .<cr>
nmap <leader>fr :History <cr>
nmap <leader>fb :Buffers <cr>
nmap <leader>bb :Buffers <cr>
nmap <leader>bn :bnext<cr>
nmap <leader>bp :bprevious<cr>
nmap <leader>b<tab> :b#<cr>

nmap <leader>tb :BlamerToggle <cr>

" plugin ----------------------------------------------------------------
" auto-pairs
let g:AutoPairsFlyMode = 0

" gitgutter
" ---
autocmd BufWritePost * GitGutter

" blamer
" ---
let g:blamer_enabled = 0
let g:blamer_delay = 500
let g:blamer_show_in_visual_modes = 0

"" fzf
" ---
" let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:fzf_preview_window = []

" defx
" ---
"打开vim自动打开defx
func! ArgFunc() abort
    let s:arg = argv(0)
    if isdirectory(s:arg)
        return s:arg
    else
        return fnamemodify(s:arg, ':h')
    endif
endfunc
" autocmd VimEnter * Defx `ArgFunc()` -no-focus -search=`expand('%:p')`

call defx#custom#option('_', {
	\ 'resume': 1,
	\ 'winwidth': 30,
	\ 'split': 'vertical',
	\ 'direction': 'topleft',
	\ 'show_ignored_files': 0,
	\ 'columns': 'indent:git:icons:filename',
	\ 'root_marker': ' ',
	\ 'profile': 1,
	\ })

call defx#custom#column('git', {
	\   'indicators': {
	\     'Modified'  : '•',
	\     'Staged'    : '✚',
	\     'Untracked' : 'ᵁ',
	\     'Renamed'   : '≫',
	\     'Unmerged'  : '≠',
	\     'Ignored'   : 'ⁱ',
	\     'Deleted'   : '✖',
	\     'Unknown'   : '⁇'
	\   }
	\ })

call defx#custom#column('mark', { 'readonly_icon': '', 'selected_icon': '' })

augroup user_plugin_defx
    autocmd!

    " Define defx window mappings
    autocmd FileType defx call <SID>defx_my_settings()

    " Delete defx if it's the only buffer left in the window
    autocmd WinEnter * if &filetype == 'defx' && winnr('$') == 1 | bdel | endif

    " Move focus to the next window if current buffer is defx
    autocmd TabLeave * if &filetype == 'defx' | wincmd w | endif

augroup END

function! s:jump_dirty(dir) abort
	" Jump to the next position with defx-git dirty symbols
	let l:icons = get(g:, 'defx_git_indicators', {})
	let l:icons_pattern = join(values(l:icons), '\|')

	if ! empty(l:icons_pattern)
		let l:direction = a:dir > 0 ? 'w' : 'bw'
		return search(printf('\(%s\)', l:icons_pattern), l:direction)
	endif
endfunction

function! s:defx_my_settings() abort
    " Define mappings
    nnoremap <silent><buffer><expr> <CR>    defx#do_action('drop')
    nnoremap <silent><buffer><expr> c       defx#do_action('copy')
    nnoremap <silent><buffer><expr> m       defx#do_action('move')
    nnoremap <silent><buffer><expr> p       defx#do_action('paste')
    nnoremap <silent><buffer><expr> h       defx#is_opened_tree() ? 
                \ defx#do_action('close_tree', defx#get_candidate().action__path) : 
                \ defx#do_action('search',  fnamemodify(defx#get_candidate().action__path, ':h'))
    nnoremap <silent><buffer><expr> l       defx#is_directory() ? defx#do_action('open_tree') : defx#do_action('drop')
    nnoremap <silent><buffer><expr> E       defx#do_action('open', 'vsplit')
    nnoremap <silent><buffer><expr> P       defx#do_action('preview')
    nnoremap <silent><buffer><expr> o		defx#do_action('open_tree', 'toggle')
    nnoremap <silent><buffer><expr> K		defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N		defx#do_action('new_file')
    nnoremap <silent><buffer><expr> M		defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> C		defx#do_action('toggle_columns', 'mark:indent:icon:filename:type:size:time')
    nnoremap <silent><buffer><expr> S		defx#do_action('toggle_sort', 'time')
    nnoremap <silent><buffer><expr> d		defx#do_action('remove')
    nnoremap <silent><buffer><expr> r		defx#do_action('rename')
    nnoremap <silent><buffer><expr> !		defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> x		defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> yy		defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> .		defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> ;		defx#do_action('repeat')
    nnoremap <silent><buffer><expr> u		defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~		defx#do_action('cd')
    nnoremap <silent><buffer><expr> q		defx#do_action('quit')
    nnoremap <silent><buffer><expr> <Space>	defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *		defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j		line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k		line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-l>	defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>	defx#do_action('print')
    nnoremap <silent><buffer><expr> cd		defx#do_action('change_vim_cwd')
endfunction


" TextEdit might fail if hidden is not set.
set hidden


" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>la  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>le  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>lc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>lo  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>st  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
