local status, ufo = pcall(require, 'ufo')
if not status then
  return
end

vim.opt.foldcolumn = '1' -- '0' is also an option
vim.opt.foldlevel = 99
vim.opt.foldenable = true
vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.opt.foldlevelstart = 99

ufo.setup {
  provider_selector = function()
    return { 'treesitter', 'indent' }
  end,
  open_fold_hl_timeout = 500, -- time in milliseconds to enable hightlight when opening a fold
  close_fold_kinds_for_ft = {},
  enable_get_fold_virt_text = true,
  preview = { -- code preview
    win_config = {
      border = 'rounded',
      winblend = 10,
    },
  },
}

-- Map key K to preview fold or show hover information from LSP
vim.keymap.set('n', 'K', function()
  local winid = ufo.peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end)

-- Autocmd to disable ufo for specific filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('local_detach_ufo', { clear = true }),
  pattern = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble', 'lazy', 'mason' },
  callback = function()
    ufo.detach()
  end,
})

return {}
