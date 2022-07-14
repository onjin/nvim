local map = require('utils').map

vim.g.mapleader = ','


-- map("i", "jk", "<esc>")
map('n', "<leader>RR", "<cmd>lua require('utils').reload_nvim_conf()<cr>")

-- registers :reg
map("n", "pp", '"*p')

-- conceal level
map("n", "<leader>vc", ":setlocal <C-R>=&conceallevel ? 'conceallevel=0' : 'conceallevel=2'<CR><CR>")

-- write modeline
map("n", "<leader>ml", ":call AppendModeline()<CR>", { silent = true })

-- utilities

-- buffers navigation
map("", "<leader>bn", ":bn<CR>")
map("", "<leader>bp", ":bp<CR>")
map("", "<leader><Tab>", ":bn<CR>")
map("", "<leader><S-Tab>", ":bp<CR>")

map("n", "<Leader>bw", ":Bw<CR>")
map("n", "<Leader>bon", ":Bonly<CR>")

map("", "<Leader>1", "<Plug>BuffetSwitch(1)")
map("", "<Leader>2", "<Plug>BuffetSwitch(2)")
map("", "<Leader>3", "<Plug>BuffetSwitch(3)")
map("", "<Leader>4", "<Plug>BuffetSwitch(4)")
map("", "<Leader>5", "<Plug>BuffetSwitch(5)")
map("", "<Leader>6", "<Plug>BuffetSwitch(6)")
map("", "<Leader>7", "<Plug>BuffetSwitch(7)")
map("", "<Leader>8", "<Plug>BuffetSwitch(8)")
map("", "<Leader>9", "<Plug>BuffetSwitch(9)")
map("", "<Leader>0", "<Plug>BuffetSwitch(0)")

-- allow to use `.` on visual selections
map("v", ".", ":norm.<CR>")

-- fast match inside (), '', and "" fi. cp, dp, cq
map("o", "p", "i(")
map("o", "q", "i'")
map("o", "Q", 'i"')

-- tab complete fuzzy tag search
map("n", "<leader>j", ":tjump /")

-- themes
map("n", "<leader>c1", ":lua require'utils'.colors('PaperColorSlim')<cr>")
map("n", "<leader>c2", ":lua require'utils'.colors('PaperColor')<cr>")
map("n", "<leader>c3", ":lua require'utils'.colors('ayu-dark')<cr>")
map("n", "<leader>c4", ":lua require'utils'.colors('tokyonight')<cr>")
map("n", "<leader>c5", ":lua require'utils'.colors('fantastic')<cr>")
map("n", "<leader>c6", ":lua require'utils'.colors('nord')<cr>")
map("n", "<leader>c7", ":lua require'utils'.colors('catppuccin')<cr>")


-- terminal
map('n', "<leader>TT", ':split term://bash<cr>')
map('n', "<leader>tv", ':split term://bash<cr>')
map("t", "<Esc>", '<C-\\><C-n>')

map("t", "<C-h>", '<C-\\><C-n><C-w>h')
map("t", "<C-j>", '<C-\\><C-n><C-w>j')
map("t", "<C-k>", '<C-\\><C-n><C-w>k')
map("t", "<C-l>", '<C-\\><C-n><C-w>l')