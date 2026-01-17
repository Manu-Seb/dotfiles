vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
-- Map 'jj' to escape in insert mode
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })

-- Normal mode
vim.api.nvim_set_keymap("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })

-- Visual mode
vim.api.nvim_set_keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- vim.keymap.set("n", "<leader>e", "<CMD>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
-- Delete line without yanking (clipboard)
vim.api.nvim_set_keymap("n", "dd", '"_dd', { noremap = true, silent = true })

-- Delete word without yanking (clipboard)
vim.api.nvim_set_keymap("n", "dw", '"_dw', { noremap = true, silent = true })
-- Navigate buffers using leader + < / >
vim.keymap.set("n", "<leader><", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>>", ":bnext<CR>", {  desc= "Next buffer" })
