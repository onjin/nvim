lint:
	selene ./lua/
style:
	stylua .

update:
	nvim --headless "+Lazy! sync" +qa

clean:
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim
	rm -rf ~/.cache/nvim

uninstall: clean
	rm -rf ~/.config/nvim
