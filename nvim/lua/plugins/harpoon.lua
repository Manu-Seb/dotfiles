local function toggle_telescope(harpoon_files)
    local ok, telescope = pcall(require, "telescope")
    if not ok then
        return
    end

    local themes = require("telescope.themes")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local previewers = require("telescope.previewers")
    local conf = require("telescope.config").values

    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    local opts = themes.get_ivy({})

    pickers.new(opts, {
        prompt_title = "Working List",
        finder = finders.new_table({
            results = file_paths,
        }),
        previewer = previewers.new_buffer_previewer({
            define_preview = function(self, entry, status)
                local filename = entry.value
                if not filename or filename == "" then
                    return
                end

                local buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(filename))
                vim.api.nvim_win_set_buf(status.preview_win, buf)
            end,
        }),
        sorter = conf.generic_sorter(opts),
    }):find()
end

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local harpoon = require("harpoon")

		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<leader>d", function()
			harpoon:list():remove()
			harpoon:list():refresh();
		end)
		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)
		vim.keymap.set("n", "<leader>fl", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Open harpoon window" })
		vim.keymap.set("n", "<C-p>", function()
			harpoon:list():prev()
		end)
		vim.keymap.set("n", "<C-n>", function()
			harpoon:list():next()
		end)
	end,
}
