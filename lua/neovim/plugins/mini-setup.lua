require("mini.icons").setup()
require("mini.git").setup()
require("mini.diff").setup()
require("mini.comment").setup()
require("mini.indentscope").setup()
require("mini.splitjoin").setup({
	mappings = {
		toggle = "<leader>T",
		split = "<leader>S",
		join = "<leader>J",
	},
	detect = {
		-- Array of Lua patterns to detect region with arguments.
		-- Default: { '%b()', '%b[]', '%b{}' }
		brackets = nil,

		-- String Lua pattern defining argument separator
		separator = ",",

		-- Array of Lua patterns for sub-regions to exclude separators from.
		-- Enables correct detection in presence of nested brackets and quotes.
		-- Default: { '%b()', '%b[]', '%b{}', '%b""', "%b''" }
		exclude_regions = nil,
	},
})

local builtin_actions = function()
	return {
		{ name = "Edit notes.md", action = "e notes.md", section = "Built-in actions" },
		{ name = "Quit all", action = "qa!", section = "Built-in actions" },
	}
end

local telescope = function()
	return function()
		return {
			{ action = "Telescope find_files", name = "Find files", section = "Telescope" },
			{ action = "Telescope command_history", name = "Command history", section = "Telescope" },
			{ action = "Telescope oldfiles", name = "Old files", section = "Telescope" },
		}
	end
end

local val = {
	[[                                __                 ]],
	[[   ___     ___    ___   __  __ /\_\    ___ ___     ]],
	[[  / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\   ]],
	[[ /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \  ]],
	[[ \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\ ]],
	[[  \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/ ]],
}
local text = table.concat(val, "\n")

local starter = require("mini.starter")
starter.setup({
	header = text,
	footer = "",
	items = {
		telescope(),
		builtin_actions(),
		starter.sections.recent_files(10, true),
	},
})
