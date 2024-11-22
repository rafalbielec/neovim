local snipe = require("snipe")
snipe.ui_select_menu = require("snipe.menu"):new({ position = "center" })
snipe.ui_select_menu:add_new_buffer_callback(function(m)
	vim.keymap.set("n", "<esc>", function()
		m:close()
	end, { nowait = true, buffer = m.buf })
end)

snipe.setup()
vim.ui.select = snipe.ui_select
vim.keymap.set("n", "s", snipe.open_buffer_menu)
