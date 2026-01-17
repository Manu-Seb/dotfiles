-- In your lazy.nvim plugins spec
return {
	"stevearc/oil.nvim",
	lazy = false,
	keys = {
		{ "-", "<cmd>Oil<cr>", desc = "Open parent directory (Oil)" },
	},
	opts = {
		default_file_explorer = true,
		view_options = {
			show_hidden = true,
			is_always_hidden = function(name, _)
				return name == ".git"
			end,
		},
		win_options = {
			wrap = false,
			signcolumn = "no",
			cursorcolumn = false,
			foldcolumn = "0",
		},
		keymaps = {
			["<CR>"] = "actions.select",
			["-"] = "actions.parent",
			["<BS>"] = "actions.parent",
			["<C-v>"] = "actions.select_vsplit",
			["<C-s>"] = "actions.select_split",
			["<C-t>"] = "actions.select_tab",
			["q"] = "actions.close",
			["g."] = "actions.toggle_hidden",
		},
		use_default_keymaps = true,
	},
}
