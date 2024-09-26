-- Define os mapeamentos personalizados
local keymap = vim.api.nvim_set_keymap

-- Opções padrão (sem noremap, com silent)
local opts = { noremap = true, silent = true }

-- Movimentar a linha inteira
-- Mapeamentos em modo Insert (insert_mode)
keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', opts)
keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', opts)
keymap('n', '<A-j>', '<Esc>:m .+1<CR>==gi', opts)
keymap('n', '<A-k>', '<Esc>:m .-2<CR>==gi', opts)

-- Navegação com Alt + setas no modo Insert
keymap('i', '<A-Up>', '<C-\\><C-N><C-w>k', opts)
keymap('i', '<A-Down>', '<C-\\><C-N><C-w>j', opts)
keymap('i', '<A-Left>', '<C-\\><C-N><C-w>h', opts)
keymap('i', '<A-Right>', '<C-\\><C-N><C-w>l', opts)

-- Retorna uma tabela vazia para evitar erro
return {}

