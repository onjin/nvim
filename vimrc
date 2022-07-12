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

lua require("init")

" source $VIMPATH/general/settings.vim
" source $VIMPATH/general/quickfix.vim
