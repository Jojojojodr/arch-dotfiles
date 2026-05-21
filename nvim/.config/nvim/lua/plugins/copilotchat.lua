return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {
			-- See Configuration section for options
		},
		keys = {
			{ "<leader>zc", "<cmd>CopilotChatToggle<cr>", desc = "Open Copilot Chat" },
		},
	},
}
