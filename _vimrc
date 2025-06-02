" set vimfiles path "
let data_dir = expand('~') . '/vimfiles' " set vimfiles path

" Instala vim-plug "
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo "' . data_dir . '/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * ++once call plug#install() | source $MYVIMRC
endif

" Plugins setup "
call plug#begin(expand('~') . '/vimfiles/plugged')
Plug 'omnisharp/omnisharp-vim' " c# plugin
Plug 'scrooloose/nerdtree' " folder navigation
Plug 'madox2/vim-ai' " ai integrated
Plug 'puremourning/vimspector' " debugger
Plug 'davidhalter/jedi-vim' " python plugin
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " fzf find file
Plug 'junegunn/fzf.vim' " fzf find file
call plug#end()

" OmniSharp setup "
let g:OmniSharp_server_stdio = 1 " Ativa comunicação do omnisharp

" NerdTree setup "
let NERDTreeShowHidden = 1 " Mostra os arquivos 

" Abre o NERDTree ao iniciar o Vim
autocmd VimEnter * NERDTree

" Aguarda 500ms e volta para a janela anterior (normalmente o buffer de edição)
autocmd VimEnter * call timer_start(50, { -> execute('normal gb') })

" Aguarda 500ms e volta para a janela anterior (normalmente o buffer de edição)
autocmd VimEnter * call timer_start(200, { -> execute('wincmd p') })

" Vim-ai setup "
let g:vim_ai_roles_config_file = expand('$ProgramFiles') . '/Vim/roles.ini'

" Hotkeys "
map <C-e> :NERDTreeToggle<CR> " "Control+o" para abrir a arvore
nnoremap <F12> :let @/ = '\<'.expand('<cword>').'\>'<CR>/\V<C-r>=@/<CR><CR>N
nnoremap <RightMouse> :let @/ = '\<'.expand('<cword>').'\>'<CR>/\V<C-r>=@/<CR><CR>N 
inoremap <F2> <C-o>:stopinsert<CR>
nnoremap <F2> u
nnoremap <F3> <C-r>
vnoremap <C-c> "+y
vnoremap <C-v> "*y
inoremap <C-c> "+y
inoremap <C-v> "*y
inoremap <C-s> <C-o>:w<CR><Esc>
nnoremap <C-s> :w<CR>
nnoremap <C-f> :/
inoremap <C-f> <C-o>:/
nnoremap <C-a> ggVG
inoremap <C-a> ggVG
nnoremap <F10> :AIChat 
inoremap <F10> <Esc>ggVG:AIChat
vnoremap <F10> :AIChat
nnoremap <C-q> :q!<CR>
inoremap <C-q> <C-o>:q!<CR>
vnoremap <C-q> <C-o>:q!<CR>
nnoremap <F8> <Esc>:Files <C-R>=getcwd()<CR><CR>
inoremap <F8> <Esc>:Files <C-R>=getcwd()<CR><CR>
vnoremap <F8> <Esc>:Files <C-R>=getcwd()<CR><CR>



" tab para o autocomplete do c# "
inoremap <expr> <Tab> pumvisible() ? '<C-n>' :                                                                                                                    
\ getline('.')[col('.')-2] =~# '[[:alnum:].-_#$]' ? '<C-x><C-o>' : '<Tab>'

syntax on

" Vim with all enhancements "
source $VIMRUNTIME/vimrc_example.vim

" Use the internal diff if available. "
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

" other configurations "
set number " Shows absolute line numbers
colorscheme elflord " Sets a built-in dark color scheme (try elflord, evening, ron, etc.)
set mouse=a " habilita o suporte ao mouse em todos os modos.
