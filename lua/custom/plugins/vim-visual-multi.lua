-- local status = pcall(require, 'vim-visual-multi')
-- if not status then
--   return
-- end

-- Hack around issue with conflicting insert mode <BS> mapping
-- between this plugin and nvim-autopairs
vim.api.nvim_create_autocmd('User', {
  pattern = 'visual_multi_start',
  callback = function()
    pcall(vim.keymap.del, 'i', '<BS>', { buffer = 0 })
  end,
})
vim.api.nvim_create_autocmd('User', {
  pattern = 'visual_multi_exit',
  callback = function()
    require('nvim-autopairs').force_attach()
  end,
})
-- Desable default mappings conflicts for vim-visual-multi
vim.g.VM_default_mappings = 0

-- new mappings
vim.g.VM_maps = {
  ['Goto Prev'] = '<S-h>', -- Shift + h preview
  ['Goto Next'] = '<S-l>', -- Shift + l next
}

return {}
