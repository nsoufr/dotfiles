function! s:CISkip()
  r "[ci skip]"
endfunction

nmap ^c :call CISkip()<CR>

map <Leader>I :g/^\(.*\)$\n\1$/d
