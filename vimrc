" Respect XDG
if isdirectory($XDG_CONFIG_HOME.'/vim')
	let $VIMPATH=expand('$XDG_CONFIG_HOME/vim')
	let $VARPATH=expand('$XDG_CACHE_HOME/vim')
else
	let $VIMPATH=expand('$HOME/.vim')
	let $VARPATH=expand('$HOME/.cache/vim')
endif

let $RTP=$VIMPATH
let $RC="$RTP/vimrc"

" let $FUZZY_FINDER='fzf'
let $FUZZY_FINDER='telescope'

" let $LSP='coc'
let $LSP='native'

source $VIMPATH/general/pre-plugins.vim
source $VIMPATH/vim-plug/plugins.vim

source $VIMPATH/general/settings.vim
source $VIMPATH/general/functions.vim
source $VIMPATH/general/mappings.vim
source $VIMPATH/general/quickfix.vim

source $VIMPATH/themes/theme.vim
" source $VIMPATH/themes/airline.vim
source $VIMPATH/themes/lualine.vim

source $VIMPATH/plug-config/black.vim
" LSP {{{
source $VIMPATH/plug-config/coc.vim
source $VIMPATH/plug-config/lsp.vim
" LSP }}}
"
source $VIMPATH/general/tmux.vim
source $VIMPATH/plug-config/cyfolds.vim
source $VIMPATH/plug-config/vim-dashboard.vim
source $VIMPATH/plug-config/nvim-autopairs.vim
source $VIMPATH/plug-config/editorconfig-vim.vim

" FUZZY_FINDER {{{
source $VIMPATH/plug-config/fzf.vim
source $VIMPATH/plug-config/telescope.vim
" FUZZY_FINDER }}}
"
"source $VIMPATH/plug-config/telekasten.vim
source $VIMPATH/plug-config/goyo.vim
source $VIMPATH/plug-config/lens.vim
source $VIMPATH/plug-config/limelight.vim
source $VIMPATH/plug-config/markdown-preview.vim
source $VIMPATH/plug-config/polyglot.vim
source $VIMPATH/plug-config/tagbar.vim
source $VIMPATH/plug-config/tree.vim
source $VIMPATH/plug-config/ultisnips.vim
source $VIMPATH/plug-config/vim-bracey.vim
source $VIMPATH/plug-config/vim-buffet.vim
source $VIMPATH/plug-config/vim-fugitive.vim
source $VIMPATH/plug-config/vim-gitgutter.vim
source $VIMPATH/plug-config/vim-grammarous.vim
source $VIMPATH/plug-config/vim-indentline.vim
source $VIMPATH/plug-config/nvim-notify.vim
source $VIMPATH/plug-config/vim-fidget.vim
source $VIMPATH/plug-config/vim-pad.vim
" source $VIMPATH/plug-config/vim-startify.vim
source $VIMPATH/plug-config/vim-surround.vim
source $VIMPATH/plug-config/vim-treesitter.vim
source $VIMPATH/plug-config/vim-test.vim
source $VIMPATH/plug-config/vim-which-key.vim
source $VIMPATH/plug-config/vimux.vim
source $VIMPATH/plug-config/vista.vim
