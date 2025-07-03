--- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

require 'custom.keymappings'
require 'custom.options'

return {

  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  }, -- renomea o fechamento logo após sair da inserção

  { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons' }, -- abas personalizadas

  { 'xiyaowong/transparent.nvim' },

  {
    'brenoprata10/nvim-highlight-colors', -- color highlight ex: '#E5C07B'
    event = 'VeryLazy',
    config = function()
      -- Configure nvim-highlight-colors
      require('nvim-highlight-colors').setup {}
    end,
  },

  {
    'max397574/colortils.nvim', -- add pick color
    event = 'VeryLazy',
    cmd = 'Colortils',
    config = function()
      require('colortils').setup()
    end,
  },

  {
    'kevinhwang91/nvim-ufo', -- add arrows to folds
    dependencies = {
      'kevinhwang91/promise-async', -- Add promise-async
    },
  },

  {
    'luukvbaal/statuscol.nvim', -- hides the number of folds leaving only the arrows
  },
  -- {
  --   'Exafunction/codeium.vim',
  --   event = 'BufEnter',
  --   dependencies = {
  --         'nvim-lua/plenary.nvim',
  --         'hrsh7th/nvim-cmp',
  --       },
  -- },
  {
    'monkoose/neocodeium', -- plugin ia neocodeium
    event = 'VeryLazy',
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig

    opts = {},
    ft = 'markdown',
  },

  {
    'glaulher/maven.nvim',
    event = 'VeryLazy',
    branch = 'refactor',
    cmd = { 'Maven', 'MavenExec' },
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('maven').setup {
        executable = 'mvn',
        -- maven_central_url = 'https://mvnrepository.com/repos/central', if nil https://central.sonatype.com/
      }
    end,
  },

  {
    'mg979/vim-visual-multi',
    branch = 'master',
  },
  {
    'javiorfo/nvim-springtime',
    lazy = true,
    cmd = { 'Springtime', 'SpringtimeUpdate' },
    dependencies = {
      'javiorfo/nvim-popcorn',
      'javiorfo/nvim-spinetta',
      'saghen/blink.cmp',
    },
    build = function()
      require('springtime.core').update()
    end,
  },
}
--  (Código Unicode: U+F51E)
--  (Código Unicode: U+F668)
--  (Código Unicode: U+EA8B)
--
-- Para algo parecido com </>:

--  (Código Unicode: U+F121)
--  (Código Unicode: U+EB84)
-- ﰩ (Código Unicode: U+F429)
--
-- -- leader + c + a = ctrl +.
-- ctrl + h j k l para mover entre as janelas
-- neotree . para root e backspace para ir a um nível acima
-- ctrl + pgdn e pgup ou gt e gT para ir entre as abas
-- f5 para debugar e f7 para debug abrir e sair visual
-- alt + N  = ctrl + d do vscode
-- alt + j ou k para mover linha
-- para selecionar no telescope usar tab dar enter e fechar o telescope
-- desfaze U  refazer ctrl + r
-- gc comenta e descomenta
-- "/texto a ser localizado" teclar enter depois / e enter para ir para a próxima ocorrência
-- %s/texto a trocar/trocado/g
-- zo  abre o bloco de código
-- zc fecha o bloco de código
-- command:  set nu ativa numero set nonu desatica
-- command: set rnu ativa numeros relativos set nornu desativa
-- com um arquivoq aberto de o comando: vertical diffsplit nome do arquivo  para desativar diffoff
-- comando Colortils abre seletor de cores e alt + enter seleciona a cor
-- saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- sd'   - [S]urround [D]elete [']quotes
-- sr)'  - [S]urround [R]eplace [)] [']
-- saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- o - para dar espaço em modo normal
