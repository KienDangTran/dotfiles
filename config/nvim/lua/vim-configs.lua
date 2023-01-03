local vo = vim.opt


-- settings
vo.laststatus = 3
vo.termguicolors = true
vo.completeopt = "menuone,preview,noselect"

-- turn on line numbering
vim.wo.number = true
vo.cursorline = true
vo.splitbelow = true
vo.splitright = true

-- sane text files
vo.fileformat = "unix"
vo.encoding = "utf-8"
vo.fileencoding = "utf-8"

-- sane editing
-- vo.expandtab = false -- insert space characters whenever the tab key is pressed, if you want to enter a real tab character use Ctrl-V<Tab>
vo.tabstop = 2 -- number of space characters that will be inserted when the tab key is pressed
vo.shiftwidth = 2 -- number of space characters inserted for indentation
vo.softtabstop = 2
vo.tw = 80
vo.smartindent = true
vo.breakindent = true --Enable break indent
vo.autowrite = true

-- mouse
vo.mouse = "a"

-- Save undo history
vo.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vo.ignorecase = true
vo.smartcase = true

-- Decrease update time
vo.updatetime = 150
vim.wo.signcolumn = "yes"

--
vo.breakindent = true -- Indent wrapped lines to match start

-- keymaps
-- copy, cut and paste
vim.api.nvim_set_keymap("v", "<C-c>", "\"+y", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-c>", "\"+y", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-x>", "\"+c", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-x>", "\"+c", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-v>", "c<ESC>\"+p", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "c<ESC>\"+p", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-v>", "<ESC>\"+pa", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<D-v>", "<ESC>\"+pa", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D-a>", "ggVG", { noremap = true, silent = true })

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
