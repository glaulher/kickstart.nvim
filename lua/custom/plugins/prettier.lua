local status, prettier = pcall(require, 'prettier')
if not status then
  return {}
end

prettier.setup {
  bin = 'prettier', -- Localização do executável do Prettier
  filetypes = {
    'css',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'json',
    'scss',
    'less',
  },
}

return {}
