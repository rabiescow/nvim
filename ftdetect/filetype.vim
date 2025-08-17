let s:cpo_save = &cpo
set cpo&vim

au BufRead,BufNewFile *.go set ft=go
au BufRead,BufNewFile *.s set ft=asm
au BufRead,BufNewFile *.tmpl set ft=gotexttmpl
au BufRead,BufNewFile *.gotext set ft=gotexttmpl
au BufRead,BufNewFile *.gohtml set ft=gohtmltmpl
au BufRead,BufNewFile go.sum set ft=gosum
au BufRead,BufNewFile go.work.sum set ft=gosum
au BufRead,BufNewFile go.work set ft=gowork

au! BufRead,BufNewFile *.mod,*.MOD
au BufRead,BufNewFile *.mod,*.MOD set ft=gomod

au BufRead,BufNewFile *.as set ft=angelscript
au BufRead,BufNewFile *.as set ft=angelscript
au BufRead,BufNewFile */ghostty/config set ft=ghostty

au BufRead,BufNewFile *.qml set ft=qml

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
