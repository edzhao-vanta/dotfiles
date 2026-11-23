" Vim skips defaults.vim when a vimrc exists, so load it explicitly.
" It turns on syntax highlighting and filetype-specific indentation.
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

set number
