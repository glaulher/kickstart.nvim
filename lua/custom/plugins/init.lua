--- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {

  { 'AndrewRadev/tagalong.vim' }, -- renomea o fechamento logo após sair da inserção

  { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons' }, -- abas personalizadas

  {
    'brenoprata10/nvim-highlight-colors', -- cores de destaque ex: '#E5C07B'
    config = function()
      -- Configura o nvim-highlight-colors
      require('nvim-highlight-colors').setup {}

      -- Integração com o nvim-cmp
      local cmp = require 'cmp'
      cmp.setup {
        -- Outras configurações do cmp
        formatting = {
          fields = { 'abbr', 'kind', 'menu' }, -- Campos necessários
          expandable_indicator = true, -- Indicador expandível
          format = require('nvim-highlight-colors').format,
        },
      }
    end,
  },

  {
    'max397574/colortils.nvim', -- adiciona pick color
    cmd = 'Colortils',
    config = function()
      require('colortils').setup()
    end,
  },

  {
    'kevinhwang91/nvim-ufo', -- adiciona seta nas dobras
    dependencies = {
      'kevinhwang91/promise-async', -- Adicionando o promise-async corretamente
    },
    opts = {
      filetype_exclude = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble', 'lazy', 'mason' },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('local_detach_ufo', { clear = true }),
        pattern = opts.filetype_exclude,
        callback = function()
          require('ufo').detach()
        end,
      })
      vim.opt.foldcolumn = '1' -- '0' is not bad
      vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.opt.foldenable = true
      vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.opt.foldlevelstart = 99

      require('ufo').setup(opts)

      -- Setup de providers
      require('ufo').setup {
        provider_selector = function()
          return { 'treesitter', 'indent' }
        end,
        open_fold_hl_timeout = 500, -- Define o tempo (em milissegundos) para exibir o highlight ao abrir uma dobra. Se não for definido, o valor padrão é 400 ms.
        close_fold_kinds_for_ft = {}, -- Configuração padrão, ajuste conforme necessário
        enable_get_fold_virt_text = true, -- Exibe texto virtual nas dobras
        preview = { -- Exibe a prévia do conteúdo dobrado
          win_config = {
            border = 'rounded',
            winblend = 10,
          },
        },
      }
      -- Mapeamento da tecla K para pré-visualização de dobras
      vim.keymap.set('n', 'K', function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          -- Fallback para o hover do LSP se não houver dobra
          vim.lsp.buf.hover()
        end
      end)
    end,
  },
  {
    'luukvbaal/statuscol.nvim', -- esconde o numero de dobras ficando apenas as setas
    opts = function()
      local builtin = require 'statuscol.builtin'
      return {
        setopt = true,
        -- override the default list of segments with:
        -- number-less fold indicator, then signs, then line number & separator
        segments = {
          { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
          { text = { '%s' }, click = 'v:lua.ScSa' },
          {
            text = { builtin.lnumfunc, ' ' },
            condition = { true, builtin.not_empty },
            click = 'v:lua.ScLa',
          },
        },
      }
    end,
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
    config = function()
      local neocodeium = require 'neocodeium'

      -- Configuração do plugin
      neocodeium.setup {
        static = {
          symbols = {
            status = {
              [0] = '󰚩 ', -- Enabled
              [1] = '󱚧 ', -- Disabled Globally
              [2] = '󱙻 ', -- Disabled for Buffer
              [3] = '󱙺 ', -- Disabled for Buffer filetype
              [4] = '󱙺 ', -- Disabled for Buffer with enabled function
              [5] = '󱚠 ', -- Disabled for Buffer encoding
            },
            server_status = {
              [0] = '󰣺 ', -- Connected
              [1] = '󰣻 ', -- Connecting
              [2] = '󰣽 ', -- Disconnected
            },
          },
        },

        -- Atualizando o status do servidor ao receber eventos
        update = {
          'User',
          pattern = { 'NeoCodeiumServer*', 'NeoCodeium*{En,Dis}abled' },
          callback = function()
            vim.cmd.redrawstatus()
          end,
        },

        -- Provedor de status com base nos símbolos
        provider = function(self)
          local symbols = self.symbols
          local status, server_status = neocodeium.get_status()
          return symbols.status[status] .. symbols.server_status[server_status]
        end,

        -- Configuração de destaque (highlight)
        hl = { fg = 'yellow' },
      }

      -- Mapeamento de chave para aceitar sugestão
      vim.keymap.set('i', '<A-a>', neocodeium.accept)
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim', -- markdown preview
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },
  {
    'smoka7/multicursors.nvim', -- multiplos seletores = ctrl + d no vscode

    event = 'VeryLazy',
    dependencies = {
      'nvimtools/hydra.nvim',
    },
    opts = {},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
      {
        mode = { 'v', 'n' },
        '<Leader>m',
        '<cmd>MCstart<cr>',
        desc = 'Create a selection for selected text or word under the cursor',
      },
    },
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
