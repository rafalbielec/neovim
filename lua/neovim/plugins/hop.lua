require("hop").setup({ keys = "1234qwerasdf" })
local key = vim.keymap.set
key("n", "<cr>", "<cmd>HopWord<cr>", { silent = true, desc = "Hop word" })
