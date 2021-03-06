set nu
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set ruler
set cm=blowfish
set tabpagemax=50

syntax on

function! s:DiffWithSaved() 
    let filetype=&ft 
    diffthis 
    vnew | r # | normal!  1Gdd 
    diffthis 
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype 
endfunction

com! DiffSaved call s:DiffWithSaved() 

nnoremap <C-d> :DiffSaved

nnoremap <tab> >>
nnoremap <S-tab> <<
vnoremap <tab> >gv
vnoremap <S-tab> <gv
"ARROW KEY TAB NAVIGATION
nnoremap [1;6D :tabp
nnoremap [1;6C :tabn
"Open
nnoremap <C-o> :tabfind 
"Comments
nnoremap <C-c> O/** *  */kA
nnoremap <C-l> o*  
nnoremap ç i<!--  -->hhhi
"Other
nnoremap <C-?> :echo bufname("%")
nnoremap <C-p> :!php -nl %
"Insert mode
inoremap <C-d> :DiffSaved
inoremap [1;6D :tabp
inoremap [1;6C :tabn
inoremap <C-o> :tabfind 
inoremap <C-c> O/** *  */kA
inoremap <C-l> *  

nnoremap Ox ddkP
nnoremap Or ddp

colorscheme molokai

let g:badwolf_darkgutter = 1
let g:badwolf_tabline = 3

set cc=101

highlight lengthWarn ctermbg=234
au BufWinEnter * match lengthWarn /\%81v.\{1,20}/

highlight OverLength ctermbg=darkred
au BufWinEnter * 2match OverLength /\%101v.\+/

au BufRead,BufNewFile *.json set syntax=javascript
au BufRead,BufNewFile *.js set syntax=es6
au BufRead,BufNewFile *.scala set syntax=scala
