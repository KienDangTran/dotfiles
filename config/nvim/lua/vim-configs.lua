-- settings
vim.opt.laststatus = 3
vim.opt.termguicolors = true
-- vim.opt.syntax = "ON"
vim.opt.completeopt = "menuone,preview,noselect"

-- turn on line numbering
vim.wo.number = true
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true

-- sane text files
vim.opt.fileformat = "unix"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- sane editing
-- vim.opt.expandtab = false -- insert space characters whenever the tab key is pressed, if you want to enter a real tab character use Ctrl-V<Tab>
vim.opt.tabstop = 2 -- number of space characters that will be inserted when the tab key is pressed
vim.opt.shiftwidth = 2 -- number of space characters inserted for indentation
vim.opt.softtabstop = 2
vim.opt.tw = 80
vim.opt.smartindent = true
vim.opt.breakindent = true --Enable break indent
vim.opt.autowrite = true

-- mouse
vim.opt.mouse = "a"

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 150
vim.wo.signcolumn = "yes"

-- keymaps
-- copy, cut and paste
vim.api.nvim_set_keymap("v", "<C-c>", "\"+y", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-x>", "\"+c", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-v>", "c<ESC>\"+p", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-v>", "<ESC>\"+pa", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })

vim.cmd [[
" wrap toggle
  setlocal nowrap
  noremap <silent> <Leader>w :call ToggleWrap()<CR>
  function ToggleWrap()
    if &wrap
      echo "Wrap OFF"
      setlocal nowrap
      set virtualedit=all
      silent! nunmap <buffer> <Up>
      silent! nunmap <buffer> <Down>
      silent! nunmap <buffer> <Home>
      silent! nunmap <buffer> <End>
      silent! iunmap <buffer> <Up>
      silent! iunmap <buffer> <Down>
      silent! iunmap <buffer> <Home>
      silent! iunmap <buffer> <End>
    else
      echo "Wrap ON"
      setlocal wrap linebreak nolist
      set virtualedit=
      setlocal display+=lastline
      noremap  <buffer> <silent> <Up>   gk
      noremap  <buffer> <silent> <Down> gj
      noremap  <buffer> <silent> <Home> g<Home>
      noremap  <buffer> <silent> <End>  g<End>
      inoremap <buffer> <silent> <Up>   <C-o>gk
      inoremap <buffer> <silent> <Down> <C-o>gj
      inoremap <buffer> <silent> <Home> <C-o>g<Home>
      inoremap <buffer> <silent> <End>  <C-o>g<End>
    endif
  endfunction
]]

vim.cmd [[
  au TermOpen * startinsert
  au TermOpen * setlocal nonumber norelativenumber
  au BufEnter * setlocal formatoptions-=cro

	" Return to last edit position when opening files It's some magic I picked up somewhere, no idea how it works or what alternatives are out there
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

	" Hightlight on yank
  augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({})
  augroup END
]]
