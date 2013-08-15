set nu
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set ruler
set cm=blowfish

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


colorscheme molokai

let g:badwolf_darkgutter = 1
let g:badwolf_tabline = 3

