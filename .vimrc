" Set to auto read when a file is changed from the outside
set autoread

" Enable filetype detection, plugins, and language-specific indentation
filetype plugin indent on

" Always show current position
set ruler

" Use spaces instead of tabs
set expandtab

"Smartab
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set softtabstop=4
set tabstop=4

"Auto indent
set ai

" Don't wrap long lines in code-oriented workflows
set nowrap

" Always show the status line
set laststatus=2

" Display line numbers
set number

" Search: case-insensitive unless pattern contains uppercase;
" show matches while typing and keep matches highlighted.
set ignorecase
set smartcase
set incsearch
set hlsearch

" Enable syntax highlighting
syntax enable

if &diff
    syntax off
endif
