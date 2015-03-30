" RSpec.vim mappings
map <Leader>R :call RunCurrentSpecFile()<CR>
map <Leader>N :call RunNearestSpec()<CR>
map <Leader>L :call RunLastSpec()<CR>
map <Leader>A :call RunAllSpecs()<CR>

" nerdcommenter
nmap <leader>/ :call NERDComment(0, "invert")<cr>
vmap <leader>/ :call NERDComment(0, "invert")<cr>

" remove writespaces
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<cr>

" global search word under cursor
nmap <leader>f :let @/="\\<<C-R><C-W>\\>"<CR>:set hls<CR>:silent Ggrep -w "<C-R><C-W>"<CR>:ccl<CR>:cw<CR><CR>

" ,k for Ag
nmap <leader>k :Ag<space>

" keep selection after in/outdent
vnoremap < <gv
vnoremap > >gv

" Gsearch
set grepprg=ag
let g:grep_cmd_opts = '--line-numbers --noheading'

" Tlist
let Tlist_Show_Menu=1
let Tlist_Highlight_Tag_On_BufEnter = 1
nmap <leader>t :TlistToggle<CR>

let g:ctrlp_map = '<leader>,'
let g:ctrlp_cmd = 'CtrlP'

nmap <leader>. :CtrlPClearCache<cr>:CtrlP<cr>
nmap <leader>l :CtrlPLine<cr>
nmap <leader>b :CtrlPBuff<cr>
nmap <leader>m :CtrlPBufTag<cr>
nmap <leader>M :CtrlPBufTagAll<cr>

let g:ctrlp_clear_cache_on_exit = 1
" ctrlp leaves stale caches behind if there is another vim process runnin
" which didn't use ctrlp. so we clear all caches on each new vim invocation
cal ctrlp#clra()

let g:ctrlp_max_height = 40

let g:Tlist_WinWidth = 40


" show on top
"let g:ctrlp_match_window_bottom = 0
"let g:ctrlp_match_window_reversed = 0

" jump to buffer in the same tab if already open
let g:ctrlp_switch_buffer = 1

" if in git repo - use git file listing command, should be faster
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files --exclude-standard -cod']

" open multiple files with <c-z> to mark and <c-o> to open. v - opening in
" vertical splits; j - jump to first open buffer; r - open first in current buffer
let g:ctrlp_open_multiple_files = 'vjr'

let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'mixed', 'line']

" Switch
" making some of the switches defined for ruby work in HAML files
autocmd FileType haml let b:switch_definitions =
      \ [
      \   g:switch_builtins.ruby_hash_style,
      \   g:switch_builtins.ruby_string,
      \   g:switch_builtins.true_false,
      \   g:switch_builtins.true_false,
      \ ]


"XMP Filter
let g:xmpfilter_cmd = "seeing_is_believing"

autocmd FileType ruby nmap <leader>E <Plug>(seeing_is_believing-mark)
autocmd FileType ruby xmap <leader>E <Plug>(seeing_is_believing-mark)
autocmd FileType ruby imap <leader>E<Plug>(seeing_is_believing-mark)

autocmd FileType ruby nmap <leader>c <Plug>(seeing_is_believing-clean)
autocmd FileType ruby xmap <leader>c <Plug>(seeing_is_believing-clean)
autocmd FileType ruby imap <leader>c <Plug>(seeing_is_believing-clean)

" auto insert mark at appropriate spot.
autocmd FileType ruby nmap <leader>e <Plug>(seeing_is_believing-run)
autocmd FileType ruby xmap <leader>e <Plug>(seeing_is_believing-run)
autocmd FileType ruby imap <leader>e <Plug>(seeing_is_believing-run)
