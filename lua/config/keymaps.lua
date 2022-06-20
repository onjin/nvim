local map = require('utils').map

vim.g.mapleader = ','


map("i", "jk", "<esc>")

-- registers :reg
map("n", "pp", '"*p')

-- conceal level
map("n", "<leader>vc", ":setlocal <C-R>=&conceallevel ? 'conceallevel=0' : 'conceallevel=2'<CR><CR>")

-- write modeline
map("n", "<leader>ml", ":call AppendModeline()<CR>", { silent = true})

-- utilities
map("n", "<leader>cs", ":!isort %<CR>")

-- buffers navigation
map("", "<leader>bn", ":bn<CR>")
map("", "<leader>bp", ":bp<CR>")
map("", "<leader><Tab>", ":bn<CR>")
map("", "<leader><js-Tab>", ":bp<CR>")

-- allow to use `.` on visual selections
map("v", ".", ":norm.<CR>")

-- fast match inside (), '', and "" fi. cp, dp, cq
map("o", "p", "i(")
map("o", "q", "i'")
map("o", "Q", 'i"')

-- tab complete fuzzy tag search
map("n", "<leader>j", ":tjump /")
