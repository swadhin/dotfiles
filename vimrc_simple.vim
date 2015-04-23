" Simple vimrc
"
" Don't put in anything that depends on extra plugins.
" Also dont assume utf-8 font support in terminal.
"
" Preamble {{{1

filetype plugin indent on

set nocompatible
set nomodeline

cnoreabbrev wq write <bar> echomsg 'run quit separately'<cr>

" Basic options {{{1

set encoding=utf-8
set autoindent
set showmode
set showcmd
set cursorline
set ttyfast
set lazyredraw
set laststatus=2
set history=1000
set shell=/bin/bash
set matchtime=3
set title
set hidden

set ruler
set nonumber

set splitbelow
set splitright

set notimeout
set nottimeout

set autoread
set autowrite

set listchars=tab:>-,eol:<,extends:>,precedes:<
set fillchars=diff:@
set backspace=indent,eol,start
set showbreak=+++\  " add a space in the end

" Wildmenu completion {{{1

set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.pyc                            " Python byte code

" Tabs, spaces, wrapping {{{1

set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab
set textwidth=80
set formatoptions=qrn1
set colorcolumn=+1
set shiftround

" Tab settings for different filetypes
augroup ft_tab_settings
    autocmd!

    autocmd FileType c setlocal noet sw=8 sts=8
    autocmd FileType cpp setlocal noet sw=8 sts=8
    autocmd FileType go setlocal noet sw=8 sts=8

    autocmd FileType html setlocal sw=2 sts=2
    autocmd FileType haml setlocal sw=2 sts=2
    autocmd FileType tex setlocal sw=2 sts=2

    autocmd FileType snippets setlocal noet ts=4
augroup END

" Text width settings for different filetypes
augroup ft_textwidth_settings
    autocmd!

    autocmd FileType help setlocal textwidth=78
    autocmd FileType mail setlocal textwidth=78
augroup END

" Backups and Spell Files {{{1

set undodir=~/.vim/tmp/undo//
set undofile
set undoreload=1000

set backupdir=~/.vim/tmp/backup//
set backup

set directory=~/.vim/tmp/swap//

if filereadable(expand("$HOME_QUICKREFS/myspell.utf-8.add"))
    execute "set spellfile=" . expand("$HOME_QUICKREFS/myspell.utf-8.add")

    " The spell file may be updated outside of vim
    execute "silent mkspell! " . &spellfile
    let &dictionary = &spellfile
endif
set spelllang=en

" Leader {{{1

let mapleader = ","
let maplocalleader = "\\"

" Color scheme {{{1

syntax on
set background=dark
colorscheme desert

" Status line {{{1

augroup ft_statuslinecolor
    au!

    au InsertEnter * hi StatusLine ctermfg=196 guifg=#FF3145
    au InsertLeave * hi StatusLine ctermfg=130 guifg=#CD5907
augroup END

set statusline=%f       " Path.
set statusline+=%m      " Modified flag.
set statusline+=%r      " Readonly flag.
set statusline+=%w      " Preview window flag.

set statusline+=%=                              " Right align.
set statusline+=(
set statusline+=%{&ff}                          " Format (unix/DOS).
set statusline+=/
set statusline+=%{strlen(&fenc)?&fenc:&enc}     " Encoding (utf-8).
set statusline+=/
set statusline+=%{&ft}                          " Type (python).
set statusline+=)

" Line and column position and counts.
set statusline+=\ (line\ %l\/%L,\ col\ %03c)

" Searching and movement {{{1

" Use plain text match case search by default.
nnoremap / /\V
vnoremap / /\V

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault
set nowrapscan

set scrolloff=3
set sidescrolloff=10

set wrap
set sidescroll=1

set virtualedit+=block

" Don't move on *
nnoremap * *<C-o>

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L g_

" Replacement for , as movement shortcut
noremap - ,

nnoremap ]q :lnext<CR>
nnoremap [q :lprev<CR>
nnoremap ]]q :lfirst<CR>
nnoremap [[q :llast<CR>

nnoremap ]w :cnext<CR>
nnoremap [w :cprev<CR>
nnoremap ]]w :cfirst<CR>
nnoremap [[w :clast<CR>

" Hitting parenthesis is hard
noremap } )
noremap { (
noremap \] }
noremap \[ {

" Search for Visually selected text with * {{{1
" http://vim.wikia.com/wiki/VimTip171

function! VSetSearch()
    let old_reg = @"
    normal! gvy
    let @/ = '\V' . @"
    normal! gV
    let @" = old_reg
endfunction

" Set the search pattern register and do a search with last pattern
" Then return to the previous position
vnoremap <silent> * :<C-U>call VSetSearch()<CR>/<CR><C-o>

" Folding {{{1

set foldlevelstart=0
set nofoldenable
set foldmethod=marker

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

function! ToggleFolding()
    if &foldenable == 1
        normal zRzn
    else
        normal zMzN
    endif
endfunction

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
" nnoremap zO zCzO

nnoremap <Leader>z :call ToggleFolding()<CR>

" DiffOrig {{{1

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
command! DiffOrig
    \ let g:difforig_ft = &ft |
    \ vert new |
    \ set bt=nofile |
    \ read ++edit # |
    \ 0d_ |
    \ let &ft = g:difforig_ft |
    \ diffthis |
    \ wincmd p |
    \ diffthis

" Strip {{{1

function! Strip(input_string)
    return substitute(a:input_string, '\v^[ \t\n\r]*(.{-})[ \t\n\r]*$', '\1', '')
endfunction

" Modescript {{{1

let g:modescript_fname = ".modescript.vim"

function! GetModeScriptFname()
    " If local modescript exists, return that first
    if filereadable(g:modescript_fname)
        return  g:modescript_fname
    endif

    " If repo modescript exists, return that next
    if executable("git")
        let reporoot=Strip(system("git rev-parse --show-toplevel 2>/dev/null"))
        if len(reporoot) > 0
            let repo_modescript_fname = reporoot . "/" . g:modescript_fname
            if filereadable(repo_modescript_fname)
                return repo_modescript_fname
            endif
        endif
    endif

    return g:modescript_fname
endfunction

function! LoadModeScript()
    let fname = GetModeScriptFname()
    if filereadable(fname)
        exe "source " . fname
    endif

    " NOTE: Changing built in command
    command! -nargs=0 Mk execute g:makecmd
    command! -nargs=0 Mk1 execute g:makecmd1
    command! -nargs=0 Mk2 execute g:makecmd2
    command! -nargs=0 Mk3 execute g:makecmd3
    command! -nargs=0 Mk4 execute g:makecmd4
    command! -nargs=0 Mk5 execute g:makecmd5
endfunction
command! -nargs=0 LoadModeScript call LoadModeScript()

augroup ft_modescript
    au!

    autocmd BufReadPost,BufNewFile * LoadModeScript
    exe "autocmd BufWritePost " . g:modescript_fname . " LoadModeScript"

    " Redefine mk with abbrev
    " I dont use mk[exrc]
    cnoreabbrev mk Mk
    cnoreabbrev mk1 Mk1
    cnoreabbrev mk2 Mk2
    cnoreabbrev mk3 Mk3
    cnoreabbrev mk4 Mk4
    cnoreabbrev mk5 Mk5

augroup END

" Convenience mappings {{{1

" I dont use ex mode
nnoremap Q gq

" Better shortcut for copy the rest of the line
nnoremap Y y$

" Clean whitespace
nnoremap <Leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Substitute
nnoremap <Leader>s :%s/\V

" Open a new file
nnoremap <Leader>n :edit <C-r>=expand('<cfile>')<CR>

" Emacs bindings in command line mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" Sudo to write
cnoremap w!! set buftype=nowrite <bar> w !sudo tee % >/dev/null

" Toggle paste
set pastetoggle=<F6>

" Toggle spell
nnoremap <F3> :setlocal spell!<CR>

" Shortcuts for completion
inoremap <C-f> <C-x><C-f>
inoremap <C-l> <C-x><C-l>
inoremap <C-Space> <C-x><C-o>

" On C-l also set nohlsearch and diffupdate
nnoremap <silent> <C-l> :nohlsearch<CR>:diffupdate<CR><C-l>

" Multiple Syntax Highlight {{{1
" Code copied from
" http://vim.wikia.com/wiki/Different_syntax_highlighting_within_regions_of_a_file

function! TextEnableCodeSnip(filetype, start, end, textSnipHl)
    let ft = toupper(a:filetype)
    let group = 'textGroup' . ft

    if exists('b:current_syntax')
        let s:current_syntax=b:current_syntax
        " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
        " do nothing if b:current_syntax is defined.
        unlet b:current_syntax
    endif

    let cmd = 'syntax include @%s syntax/%s.vim'
    let cmd = printf(cmd, group, a:filetype)
    execute cmd
    try
        let cmd = 'syntax include @%s after/syntax/%s.vim'
        let cmd = printf(cmd, group, a:filetype)
        execute cmd
    catch
    endtry

    if exists('s:current_syntax')
        let b:current_syntax = s:current_syntax
    else
        unlet b:current_syntax
    endif

    let cmd = 'syntax region textSnip%s matchgroup=%s start=%s end=%s contains=@%s'
    let cmd = printf(cmd, ft, a:textSnipHl, a:start, a:end, group)
    execute cmd
endfunction

" Quick editing {{{1

cnoreabbrev ev edit <C-r>=$MYVIMRC<CR>
cnoreabbrev evs edit <C-r>=$HOME_DOTFILES<CR>/vimrc_simple.vim
cnoreabbrev evp edit <C-r>=$HOME_DOTFILES<CR>/vimrc_plugins.vim
cnoreabbrev et edit <C-r>=$HOME<CR>/.tmux.conf
cnoreabbrev em edit <C-r>=GetModeScriptFname()<CR>

if !exists("*ReloadConfigs")
    function! ReloadConfigs()
        source ~/.vimrc

        if has("gui_running")
            source ~/.gvimrc
        endif
    endfunction
endif
command! -nargs=0 ReloadConfigs call ReloadConfigs()
cnoreabbrev rc ReloadConfigs

" RepoSync {{{1

command! -nargs=0 RepoSync !repo-sync
cnoreabbrev rs RepoSync

" Various filetype-specific stuff {{{1

" ReStructuredText {{{2

augroup ft_rest
    au!

    au Filetype rst nnoremap <buffer> <localleader>1 yypVr=
    au Filetype rst nnoremap <buffer> <localleader>2 yypVr-
    au Filetype rst nnoremap <buffer> <localleader>3 yypVr~
    au Filetype rst nnoremap <buffer> <localleader>4 yypVr`
augroup END

" Markdown {{{2

function! MarkdownLevel()
    if strpart(getline(v:lnum), 0, 2) ==# "# "
        return ">1"
    elseif strpart(getline(v:lnum), 0, 3) ==# "## "
        return ">2"
    elseif strpart(getline(v:lnum), 0, 4) ==# "### "
        return ">3"
    elseif strpart(getline(v:lnum), 0, 5) ==# "#### "
        return ">4"
    elseif strpart(getline(v:lnum), 0, 6) ==# "##### "
        return ">5"
    elseif strpart(getline(v:lnum), 0, 7) ==# "###### "
        return ">6"
    elseif strpart(getline(v:lnum), 0, 8) ==# "####### "
        return ">7"
    else
        return "="
    endif
endfunction

augroup ft_markdown
    au!

    au Filetype markdown nnoremap <buffer> <localleader>1 0i# <Esc>
    au Filetype markdown nnoremap <buffer> <localleader>2 0i## <Esc>
    au Filetype markdown nnoremap <buffer> <localleader>3 0i### <Esc>
    au Filetype markdown nnoremap <buffer> <localleader>4 0i#### <Esc>
    au Filetype markdown let b:surround_105 = "*\r*"
    au Filetype markdown let b:surround_98 = "**\r**"
    au Filetype markdown setlocal nofoldenable
    au Filetype markdown setlocal suffixesadd=.md
    au Filetype markdown setlocal iskeyword+=-
    au Filetype markdown setlocal formatoptions-=n
augroup END

" MoinMoin {{{2

augroup ft_moin
    au!

    au Filetype moin nnoremap <buffer> <localleader>1 0i= <Esc>$a =<Esc>
    au Filetype moin nnoremap <buffer> <localleader>2 0i== <Esc>$a ==<Esc>
    au Filetype moin nnoremap <buffer> <localleader>3 0i=== <Esc>$a ===<Esc>
    au Filetype moin nnoremap <buffer> <localleader>4 0i==== <Esc>$a ====<Esc>
    au Filetype moin let b:surround_105 = "''\r''"
    au Filetype moin let b:surround_98 = "'''\r'''"
augroup END

" Latex {{{2

augroup ft_tex
    au!

    au Filetype tex let b:surround_105 = "\\textit{\r}"
    au Filetype tex let b:surround_98 = "\\textbf{\r}"
    au Filetype tex nnoremap <buffer> <Localleader>t :Tab /\v(\&<Bar>\\\\ \\hline)
    au Filetype tex setlocal formatoptions-=n
augroup END


" Python {{{2

augroup ft_python
    au!

    au FileType python setlocal commentstring=#\ %s

" Text {{{2

augroup ft_text
    au!

    au Filetype text setlocal formatoptions-=n
augroup END

" Bookmark {{{2

function! BookmarkLevel()
    if getline(v:lnum) ==# "-"
        return ">1"
    else
        return "="
    endif
endfunction

" Setup stuff depending on filename/extension {{{1
augroup ft_setup
    au!

    " Setup the proper filetype
    autocmd BufReadPost,BufNewFile *.md setlocal ft=markdown
    au BufEnter *.md setlocal foldexpr=MarkdownLevel()
    au BufEnter *.md setlocal foldmethod=expr

    au BufEnter bookmarks.yaml setlocal foldexpr=BookmarkLevel()
    au BufEnter bookmarks.yaml setlocal foldmethod=expr

    autocmd BufReadPost,BufNewFile *.plot setlocal ft=gnuplot
    autocmd BufReadPost,BufNewFile *.php setlocal ft=php.html
    autocmd BufReadPost,BufNewFile *.jsx setlocal ft=javascript
    autocmd BufReadPost,BufNewFile *.jinja2 setlocal ft=jinja
    autocmd BufReadPost,BufNewFile *.blog setlocal ft=markdown
    autocmd BufReadPost,BufNewFile *.twig setlocal ft=htmljinja
    autocmd BufReadPost,BufNewFile *.sshconfig setlocal ft=sshconfig

    autocmd BufReadPost,BufNewFile *.html.jinja2 setlocal ft=htmljinja

    autocmd BufReadPost,BufNewFile bashrc_* setlocal ft=sh

    autocmd BufReadPost,BufNewFile *.blog call TextEnableCodeSnip("yaml", '/\v%^/', '/\V.../', "yaml")
augroup END

