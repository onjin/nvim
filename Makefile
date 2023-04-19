update:
	nvim --headless "+Lazy! sync" +qa

clean:
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim
	rm -rf ~/.cache/nvim
	rm -rf ~/.config/nvim/plugin/

uninstall: clean
	rm -rf ~/.config/nvim

lint:
	selene ./lua/
