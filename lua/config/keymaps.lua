local map = require('utils').map

vim.g.mapleader = ','


-- map("i", "jk", "<esc>")

-- registers :reg
map("n", "pp", '"*p')

-- conceal level
map("n", "<leader>vc", ":setlocal <C-R>=&conceallevel ? 'conceallevel=0' : 'conceallevel=2'<CR><CR>")

-- write modeline
map("n", "<leader>ml", ":call AppendModeline()<CR>", { silent = true })

-- utilities
map("n", "<leader>cs", ":!isort %<CR>")

-- buffers navigation
map("", "<leader>bn", ":bn<CR>")
map("", "<leader>bp", ":bp<CR>")
map("", "<leader><Tab>", ":bn<CR>")
map("", "<leader><S-Tab>", ":bp<CR>")

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
