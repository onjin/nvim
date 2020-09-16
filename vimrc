" Respect XDG
if isdirectory($XDG_CONFIG_HOME.'/vim')
	let $VIMPATH=expand('$XDG_CONFIG_HOME/vim')
	let $VARPATH=expand('$XDG_CACHE_HOME/vim')
else
	let $VIMPATH=expand('$HOME/.vim')
	let $VARPATH=expand('$HOME/.cache/vim')
endif

source $VIMPATH/vim-plug/plugins.vim

source $VIMPATH/general/settings.vim
source $VIMPATH/general/functions.vim
source $VIMPATH/general/mappings.vim
source $VIMPATH/general/tmux.vim

source $VIMPATH/themes/theme.vim
source $VIMPATH/themes/airline.vim

source $VIMPATH/plug-config/coc.vim
source $VIMPATH/plug-config/cyfolds.vim
source $VIMPATH/plug-config/editorconfig-vim.vim
source $VIMPATH/plug-config/fzf.vim
source $VIMPATH/plug-config/goyo.vim
source $VIMPATH/plug-config/lens.vim
source $VIMPATH/plug-config/limelight.vim
source $VIMPATH/plug-config/tagbar.vim
source $VIMPATH/plug-config/ultisnips.vim
source $VIMPATH/plug-config/vim-doge.vim
source $VIMPATH/plug-config/vim-textobj.vim
source $VIMPATH/plug-config/vim-which-key.vim
