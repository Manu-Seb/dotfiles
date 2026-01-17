return {
	{
		"ojroques/vim-oscyank",
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({})
		end,
	},
	{
		"numToStr/Comment.nvim",
	},
	{
		"folke/snacks.nvim",
		event = "VeryLazy",
		opts = {
			indent = {
				enabled = true, -- ▎▎▎▎ current scope
				only_current = true, -- Only current indent level
				char = "▎",
				animated = false,
				delay = 0,
				duration = 0,
			},
			dashboard = {
				enabled = true,
			},
		},
		keys = {
			{ "<leader>ug", "<cmd>SnacksToggle indent<cr>", desc = "Toggle indent scope" },
		},
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = { enabled = false }, -- Let snacks handle scope
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"lazy",
					"TelescopePrompt",
					"snacks_dashboard",
				},
			},
		},
		keys = {
			{ "<leader>ui", "<cmd>IblToggle<cr>", desc = "Toggle indent lines" },
		},
	},
	{
		"vimpostor/vim-tpipeline",
		config = function()
			-- Automatically embed Vim statusline into Tmux
			vim.g.tpipeline_autoembed = 1
			vim.g.tpipeline_restore = 1
			vim.g.tpipeline_clearstl = 1
		end,
	},
}
