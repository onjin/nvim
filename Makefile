update:
	nvim /tmp --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
clear:
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim
	rm -rf ~/.cache/nvim
uninstall: clear
	rm -rf ~/.config/nvim
