" vint: -ProhibitAutocmdWithNoGroup

autocmd BufRead,BufNewFile *.rs set filetype=rust
autocmd BufRead,BufNewFile Cargo.toml if &filetype == "" | set filetype=cfg | endif
