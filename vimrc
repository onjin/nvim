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

source $VIMPATH/general/pre-plugins.vim
source $VIMPATH/vim-plug/plugins.vim

source $VIMPATH/general/settings.vim
source $VIMPATH/general/functions.vim
source $VIMPATH/general/mappings.vim
source $VIMPATH/general/tmux.vim

source $VIMPATH/themes/theme.vim
source $VIMPATH/themes/airline.vim

source $VIMPATH/plug-config/black.vim
" source $VIMPATH/plug-config/coc.vim
" source $VIMPATH/plug-config/coc-explorer.vim
source $VIMPATH/plug-config/cyfolds.vim
source $VIMPATH/plug-config/editorconfig-vim.vim
source $VIMPATH/plug-config/fzf.vim
source $VIMPATH/plug-config/goyo.vim
source $VIMPATH/plug-config/lens.vim
source $VIMPATH/plug-config/limelight.vim
source $VIMPATH/plug-config/lsp-config.vim
source $VIMPATH/plug-config/markdown-preview.vim
source $VIMPATH/plug-config/polyglot.vim
source $VIMPATH/plug-config/tagbar.vim
source $VIMPATH/plug-config/ultisnips.vim
source $VIMPATH/plug-config/vim-doge.vim
source $VIMPATH/plug-config/vim-bracey.vim
source $VIMPATH/plug-config/vim-buffet.vim
source $VIMPATH/plug-config/vim-fugitive.vim
source $VIMPATH/plug-config/vim-gitgutter.vim
source $VIMPATH/plug-config/vim-grammarous.vim
source $VIMPATH/plug-config/vim-pad.vim
source $VIMPATH/plug-config/vim-startify.vim
source $VIMPATH/plug-config/vim-surround.vim
source $VIMPATH/plug-config/vim-which-key.vim
source $VIMPATH/plug-config/vista.vim

luafile $VIMPATH/lua/plugins/compe-config.lua
luafile $VIMPATH/lua/plugins/lsp-config.lua
luafile $VIMPATH/lua/lsp/bash-lsp.lua
luafile $VIMPATH/lua/lsp/javascript-lsp.lua
luafile $VIMPATH/lua/lsp/php-lsp.lua
luafile $VIMPATH/lua/lsp/python-lsp.lua
luafile $VIMPATH/lua/lsp/vim-lsp.lua
