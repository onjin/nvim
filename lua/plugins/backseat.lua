return {
	{
		"james1236/backseat.nvim",
		config = function()
			require("backseat").setup({
				openai_api_key = "example",
				openai_model_id = "gpt-3.5-turbo",
				additional_instructions = "Give ideas for how to optimize the code, and provide ideas for unimplemented areas marked with the todo!() macro or TODO comments.",
			})
		end,
	},
}
