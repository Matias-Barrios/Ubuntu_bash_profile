
" .vimrc 
" Author : Matias Barrios
" Year : 2017
" ''

" Customizing general vim properties 
" ----------------------------------
syntax on
set term=xterm-256color
set laststatus=2
set statusline=%F\ [FORMAT=%{&ff}][TYPE=%Y][ASCII=\%03.3b][HEX=\%02.2B]\ %=\ [POS=%04l,%04v][%p%%][LEN=%L]

" Global variables set:
" ---------------------
"

let g:normal_mode_color_fg = 'Cyan'
let g:normal_mode_color_bg = 'Black'
let g:insert_mode_color_fg = 'Green'
let g:insert_mode_color_bg = 'Black'
"
" END GLOBAL

" The below autocommand group hihglights the status bar depending
" on the mode user is in
augroup Highlighting_Group
	autocmd!
	function! InsertMode()
			execute 'hi statusline ctermfg=' . g:insert_mode_color_fg . ' ctermbg=' . g:insert_mode_color_bg
	endfunction
	
	function! NormalMode()
			execute 'hi statusline ctermfg=' . g:normal_mode_color_fg . ' ctermbg=' . g:normal_mode_color_bg
	endfunction
	au InsertEnter * call InsertMode()
	au InsertLeave,BufWritePost * call NormalMode()
augroup END

" Startup actions :
" Things I need to do right after vim starts. For instance, highlighting
" corectly the status bar 
call NormalMode()
" END OF GENERAL SETUP
" --------------------

highlight Search ctermfg=White ctermbg=Cyan
highlight DiffAdd      cterm=none ctermfg=White ctermbg=Green
highlight DiffChange   cterm=none ctermfg=White ctermbg=Brown
highlight DiffDelete   cterm=bold ctermfg=White ctermbg=Red
highlight DiffText     cterm=none ctermfg=White ctermbg=Gray

if &diff
	syntax off
endif

