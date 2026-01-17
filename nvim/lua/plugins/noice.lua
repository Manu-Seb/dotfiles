return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
	config = function()
		require("noice").setup({
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			cmdline = {
				enabled = true,
				view = "cmdline_popup", -- ← POPUP VIEW (what you want)
			},
			views = {
				cmdline_popup = {
					position = {
						row = 8, -- Position from top
						col = "50%",
					},
					size = {
						width = "80%",
						height = 1,
					},
					notify = {
						max_width = 80,
						max_height = 10,
					},
				},
			},
			presets = {
				bottom_search = false, -- No bottom bar
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = false,
			},
		})
	end,
}
