local opts = {
	ignore = "^$",
	toggler = {
		line = "<leader>/",
		block = "<leader>b/",
	},
	opleader = {
		line = "<leader>/",
		block = "<leader>b",
	},
}
return {
	{
		"numToStr/Comment.nvim",
    opts = opts,
	},
}
