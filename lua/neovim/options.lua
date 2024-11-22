-- vimscript settings
vim.cmd([[
set shortmess=A " disable swap files
set notimeout " no keys timeout
set encoding=utf-8 " default encoding for everything

" configure colourful cursor for some terminals
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175
]])

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smarttab = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 1000

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"
vim.opt.termguicolors = true
-- Show which line your cursor is on
vim.opt.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 15
vim.opt.smoothscroll = true
vim.opt.cursorlineopt = "number"
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.wrap = true
vim.opt.splitright = true
vim.opt.startofline = true
vim.opt.foldlevel = 99
vim.opt.mousemoveevent = true
-- Always show line numbers
vim.opt.number = true
vim.opt.numberwidth = 2
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"
-- Mode displayed at the bottom of the screen
vim.opt.showmode = true
-- Enable clipbowrd
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Display a vertical bar at 80 characters
vim.opt.colorcolumn = "80"
vim.cmd([[hi colorcolumn guibg='Green']])
