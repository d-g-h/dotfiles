" Plugins {{{
function! VimrcLoadPlugins()
  let g:python_host_prog='/usr/local/bin/python2'
  let g:python3_host_prog='/usr/local/bin/python3'
  " Install vim-plug if not available {{{
  if !isdirectory(g:vim_plug_dir)
    call mkdir(g:vim_plug_dir, 'p')
  endif
  if !isdirectory(g:vim_plug_dir.'/autoload')
    execute '!git clone git://github.com/junegunn/vim-plug '
          \ shellescape(g:vim_plug_dir.'/autoload', 1)
  endif
  " }}}
  call plug#begin()
  " Misc {{{
  Plug 'jparise/vim-graphql'
  Plug 'tpope/vim-unimpaired'
  Plug 'tmux-plugins/vim-tmux'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'justinmk/vim-dirvish'
  Plug 'scrooloose/nerdcommenter'
  Plug 'tpope/vim-eunuch'
  Plug 'bling/vim-airline'
  Plug 'Shougo/vinarise.vim'
  Plug 'vim-scripts/DrawIt'
  Plug 'altercation/vim-colors-solarized'
  Plug 'danro/rename.vim'
  Plug 'pangloss/vim-javascript'
  Plug 'mxw/vim-jsx'
  Plug 'digitaltoad/vim-jade'
  Plug 'nicklasos/vim-jsx-riot'
  Plug 'godlygeek/tabular'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'mattn/emmet-vim'
  Plug 'vim-scripts/vim-auto-save'
  Plug 'leafgarland/typescript-vim'
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'othree/html5.vim'
  Plug 'hail2u/vim-css3-syntax'
  Plug 'digitaltoad/vim-pug'
  Plug 'rhysd/vim-grammarous'
  Plug 'dNitro/vim-pug-complete', { 'for': ['jade', 'pug'] }
  Plug 'prettier/vim-prettier', { 'do': 'npm install' }
  Plug 'airblade/vim-gitgutter'
  Plug 'posva/vim-vue'
  Plug 'elubow/cql-vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " }}}
  let g:prettier#autoformat_config_present = 0
  let g:prettier#quickfix_auto_focus = 0
  let g:prettier#quickfix_enabled = 0
  let g:grammarous#default_comments_only_filetypes = { '*' : 1, 'help' : 0, 'markdown' : 0 }
  autocmd OptionSet guicursor noautocmd set guicursor=
  " FZF {{{
  " let fzf_command = '((git ls-files && git ls-files --exclude-standard --cached --others 2> /dev/null)'  " git
  " let fzf_command .= ' || (hg manifest --all 2> /dev/null)'  " mercurial
  " let fzf_command .= ' || (bzr ls --versioned --recursive 2> /dev/null)'  " bzr
  " let fzf_command .= ' || (find -type d -name ".svn" -prune -o \( -type f -o -type l \) -print | cut -c3-)) | sort | uniq'  " svn and normal directories
  " let $FZF_DEFAULT_COMMAND=fzf_command
  let $FZF_DEFAULT_COMMAND='ag -l -g ""'
  nnoremap <silent> <c-p> :FZF<cr>
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
  " }}}
  " Ale {{{
  Plug 'dense-analysis/ale'
  " Enable completion where available.
  let g:ale_completion_enabled = 1
  " }}}
  " UltiSnips {{{
  if g:has_python
    let g:UltiSnipsEditSplit = 'normal'
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<c-b>"
    let g:UltiSnipsJumpBackwardTrigger="<c-z>"
  endif
  " }}}
  " undotree {{{
  Plug 'mbbill/undotree'
  nnoremap <leader>u :UndotreeToggle<cr>
  " }}}
  " Fugitive {{{
  nnoremap <leader>gs :Gstatus<cr>
  nnoremap <leader>gd :Gdiff<cr>
  nnoremap <leader>gb :Gblame<cr>
  nnoremap <leader>gw :Gwrite
  nnoremap <leader>gr :Gread
  nnoremap <leader>dp :diffput<cr>:diffupdate<cr>
  vnoremap <leader>dp :diffput<cr>:diffupdate<cr>
  nnoremap <leader>dg :diffget<cr>:diffupdate<cr>
  vnoremap <leader>dg :diffget<cr>:diffupdate<cr>
  Plug 'tpope/vim-fugitive'
  " }}}
  call plug#end()
endfunction

" }}}
" Mappings {{{

function! VimrcLoadMappings()
  " Misc {{{
  " enable AutoSave on Vim startup
  let g:auto_save = 0
  let g:mapleader = ","
  " execute the current line or selection
  nnoremap <silent> <leader>t "ryy:@r<cr>
  vnoremap <silent> <leader>t "rygv:@r<cr>
  " toggle spell on/off
  nnoremap <silent> <leader>s :set spell!<cr>
  " Allow using the repeat operator with a visual selection (!)
  " http://stackoverflow.com/a/8064607/127816
  vnoremap . :normal .<cr>
  " edit vimrc
  nnoremap <leader>e :e $MYVIMRC<cr>
  " clear search highlight with ,c
  nnoremap <silent> <leader>c :noh<cr>
  " search/replace the word under the cursor
  nnoremap <leader>z :let @z = expand("<cword>")<cr>q:i%s/\C\v<<esc>"zpa>//g<esc>hi
  " help
  inoremap <f1> <esc>:help
  nnoremap <f1> <esc>:help
  vnoremap <f1> <esc>:help
  " move text up/down
  nnoremap <silent> <c-j> :m .+1<cr>==
  nnoremap <silent> <c-k> :m .-2<cr>==
  vnoremap <silent> <c-j> :m '>+1<cr>gv=gv
  vnoremap <silent> <c-k> :m '<-2<cr>gv=gv
  " }}}
  " Quickfix/location list {{{
  augroup quick_loc_list
    au! BufWinEnter quickfix nnoremap <silent> <buffer>
          \	q :cclose<cr>:lclose<cr>
  augroup END
  nnoremap <silent> <leader>q :botright copen 10<cr>
  nnoremap <silent> <leader>l :botright lopen 10<cr>
  " }}}
  " Window/buffer navigation and manipulation {{{
  nnoremap <leader>e :e $MYVIMRC<cr>
  " zoom with <c-w>z in any mode
  nnoremap <silent> <c-w>z :ZoomWinTabToggle<cr>
  inoremap <silent> <c-w>z <c-\><c-n>:ZoomWinTabToggle<cr>a
  vnoremap <silent> <c-w>z <c-\><c-n>:ZoomWinTabToggle<cr>gv
  if has('nvim') && exists(':tnoremap')
    tnoremap <c-w>j <c-\><c-n><c-w>j
    tnoremap <c-w>k <c-\><c-n><c-w>k
    tnoremap <c-w>h <c-\><c-n><c-w>h
    tnoremap <c-w>l <c-\><c-n><c-w>l
    tnoremap <pageup> <c-\><c-n><pageup>
    tnoremap <pagedown> <c-\><c-n><pagedown>
    tnoremap <silent> <c-w>z <c-\><c-n>:ZoomWinTabToggle<cr>
  endif
  " }}}
  " REPL integration {{{
  nnoremap <silent> <f6> :REPLSendLine<cr>
  vnoremap <silent> <f6> :REPLSendSelection<cr>
  " }}}
endfunction

" }}}
" Settings {{{

function! VimrcLoadSettings()
  set guicursor=i:ver25-iCursor
  set backspace=indent,eol,start                       " backspace over everything in insert mode
  set nobackup                                         " no need for backup files(use undo files instead)
  set undofile                                         " create '.<FILENAME>.un~' for persiting undo history
  set directory=~/.config/nvim/swap/                   " swap files storage, first try in the cwd then in /tmp
  set undodir=~/.config/nvim/swap/                     " undo files storage, only allow the same directory
  set history=500                                      " 500 lines of command-line history
  set mouse=a                                          " enable mouse
  set noerrorbells visualbell t_vb=                    " disable annoying terminal sounds
  set encoding=utf-8                                   " universal text encoding, compatible with ascii
  set noequalalways
  set list
  set listchars=tab:›\ ,trail:•,extends:#,nbsp:.       " Highlight problematic whitespace
  set linespace=0                                      " No extra spaces between rows
  set fillchars=diff:⣿,vert:│
  set spell                                            " Spell checking on
  set showcmd                                          " display incomplete commands
  set completeopt=menu,menuone,longest                 " disable preview scratch window
  set complete=.,w,b,u,t                               " h: 'complete'
  set pumheight=15                                     " limit completion menu height
  set number                                           " display line numbers on the left
  set expandtab                                        " expand tabs into spaces
  set softtabstop=2                                    " number of spaces used with tab/bs
  set tabstop=2                                        " display tabs with the width of two spaces
  set shiftwidth=2                                     " indent with two spaces
  set ignorecase                                       " ignore case when searching
  set smartcase                                        " disable 'ignorecase' if search pattern has uppercase characters
  set incsearch                                        " highlight matches while typing search pattern
  set hlsearch                                         " highlight previous search matches
  set showmatch                                        " briefly jump to the matching bracket on insert
  set matchtime=2                                      " time in decisecons to jump back from matching bracket
  set wrap                                             " automatically wrap text when 'textwidth' is reached
  set foldmethod=manual                                " by default, fold using indentation
  set nofoldenable                                     " don't fold by default
  set foldlevel=0                                      " if fold everything if 'foldenable' is set
  set foldnestmax=10                                   " maximum fold depth
  set synmaxcol=500                                    " maximum length to apply syntax highlighting
  set timeout                                          " enable timeout of key codes and mappings(the default)
  set timeoutlen=1000                                  " big timeout for key sequences
  set ttimeout
  set ttimeoutlen=0                                    " small timeout for key sequences since these will be normally scripted
  set cursorline                                       " Highlight current line
  set colorcolumn=120
  if has('cmdline_info')
    set ruler                                          " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                                        " Show partial commands in status line and
  endif
  if has('statusline')
    set laststatus=2
                                                       " Broken down into easily includeable segments
    set statusline=%<%f\                               " Filename
    set statusline+=%w%h%m%r                           " Options
    set statusline+=%{fugitive#statusline()}           " Git Hotness
    set statusline+=\ [%{&ff}/%Y]                      " Filetype
    set statusline+=\ [%{getcwd()}]                    " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%            " Right aligned file nav info
  endif
  if $DISABLE_UNNAMED_CLIP != '1'
    set clipboard+=unnamedplus
  endif
  set backupskip=/tmp/*,/private/tmp/* " make it possible to use vim to edit crontab
  augroup global_settings
    au!
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  augroup END
endfunction

" }}}
" File type settings {{{
function! VimrcLoadFiletypeSettings()
  augroup filetype_settings
    au!
    " my vimrc may not have the usual path
    au BufNewFile,BufRead $MYVIMRC setl filetype=vim
    " html with mustaches
    au  BufNewFile,BufRead *.html.mustache,*.html.handlebars,*.html.hbs,*.html.hogan,*.html.hulk setl filetype=html.mustache
    " extra zsh files without extensions
    au BufNewFile,BufRead $ZDOTDIR/functions/**/* setl filetype=zsh
    au BufNewFile,BufRead $ZDOTDIR/completion-functions/* setl filetype=zsh
    au BufNewFile,BufRead $ZDOTDIR/plugins/**/functions/* setl filetype=zsh
    " riot/jsx
    au BufNewFile,BufRead *.riot.tag setlocal ft=javascript
    " Coffeescript {{{
    au FileType coffee
          \   setl foldmethod=marker
          \ | setl foldenable
    " }}}
    " Html {{{
    au BufNewFile,BufRead *.ejs set filetype=html
    au FileType html
          \   setl foldmethod=marker
          \ | setl foldenable
    " }}}
    " Vim {{{
    au FileType vim
          \   setl foldmethod=manual
          \ | setl foldenable
    " }}}
    " Vim {{{
    au FileType dirvish
          \   setl nospell
    " }}}
    " C/C++ {{{
    au FileType c,cpp
          \   nnoremap <buffer> <silent> <leader>ff :call Uncrustify('c')<cr>
          \ | setl commentstring=//%s
    " }}}
    " Zsh/sh {{{
    au FileType sh,bash,zsh setl noexpandtab
    au FileType zsh
          \   runtime! indent/sh.vim
          \ | setl foldmethod=marker
          \ | setl foldenable
    " }}}
    " Python {{{
    au FileType python
          \   setl softtabstop=4
          \ | setl shiftwidth=4
          \ | setl textwidth=79
    command! DocTest !python3 -m doctest %
    " }}}
    " Manifest {{{
    au BufNewFile,BufRead *.manifest set filetype=JSON
    " }}}
  augroup END
endfunction
" }}}
" Colors {{{
function! VimrcLoadFontsColors()
  set background=dark
  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  " Set this. Airline will handle the rest.
  let g:airline#extensions#ale#enabled = 1
  let g:airline_left_sep='❯'
  let g:airline_right_sep=''
  let g:airline_symbols.branch='⎇ '
  let g:airline_symbols.linenr='№'
  let g:solarized_termcolors=256
  let g:solarized_termtrans=1
  let g:solarized_contrast="normal"
  let g:solarized_visibility="normal"
  color solarized             " Load a colorsch
  if $TERM =~ 'screen-256color' || $TERM =~ 'rxvt-unicode-256color' || $TERM =~ 'xterm-256color'
    " for tmux, this will only work if the client terminal supports italic
    " escape sequences
    highlight Comment cterm=italic
  endif
endfunction
" }}}
" Terminal {{{
if has('nvim')
  augroup Terminal
    au!
    au TermOpen * let g:last_terminal_job_id = b:terminal_job_id
    au WinEnter term://* startinsert
  augroup END
endif
" }}}
" Functions {{{
function! s:GetVisual()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][:col2 - 2]
  let lines[0] = lines[0][col1 - 1:]
  return lines
endfunction

function! REPLSend(lines)
  call jobsend(g:last_terminal_job_id, add(a:lines, ''))
endfunction
" }}}
" Commands {{{
" REPL integration {{{
command! -range=% REPLSendSelection call REPLSend(s:GetVisual())
command! REPLSendLine call REPLSend([getline('.')])
" }}}
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.  Only define it when not
" defined already.
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis
" }}}
" Initialization {{{
call VimrcLoadMappings()
if !exists('g:vimrc_initialized')
  let g:is_windows = has('win32') || has('win64')
  " Little hack to set the $MYVIMRC from the $VIMINIT in the case it was used to 
  " initialize vim.
  if empty($MYVIMRC)
    let $MYVIMRC = substitute($VIMINIT, "^source ", "", "g")
  endif
  " Extract the directory from $MYVIMRC
  let g:rc_dir = strpart($MYVIMRC, 0, strridx($MYVIMRC, (g:is_windows ? '\' : '/')))
  let $RCDIR = g:rc_dir
  let g:plugins_dir = g:rc_dir.'/plugged'
  let g:vim_plug_dir = g:plugins_dir.'/vim-plug'
  let &runtimepath = g:rc_dir.','.g:vim_plug_dir.','.$VIMRUNTIME
  if !exists('g:disable_plugins')
    let g:has_python = has('python')
    call VimrcLoadPlugins()
  else
    call plug#begin()
    " only load vim-sensible
    Plug 'tpope/vim-sensible'
    call plug#end()
  endif
  let g:vimrc_initialized = 1
endif
call VimrcLoadSettings()
call VimrcLoadFiletypeSettings()
call VimrcLoadFontsColors()
" }}}
