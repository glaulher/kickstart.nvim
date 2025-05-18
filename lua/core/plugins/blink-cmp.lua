return {
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
      'brenoprata10/nvim-highlight-colors',
      {
        'luckasRanarison/tailwind-tools.nvim',
        name = 'tailwind-tools',
        build = ':UpdateRemotePlugins',
        dependencies = {
          'nvim-treesitter/nvim-treesitter',
          'nvim-telescope/telescope.nvim', -- optional
          'neovim/nvim-lspconfig', -- optional
        },
        opts = {}, -- your configuration
      },
      -- Codeium completion source
      -- 'Exafunction/codeium.nvim', -- adicionei essa linha
    },
    opts = {
      keymap = {
        preset = 'default',
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          window = { border = 'single' },
        },

        menu = {

          border = 'single',
          draw = {
            columns = {

              { 'label', 'label_description', gap = 1 },
              { 'kind_icon', gap = 1, 'kind' },
            },
            components = {

              kind_icon = {
                text = function(ctx)
                  local kind_icons = {
                    Array = ' ',
                    Boolean = '󰨙 ',
                    Class = ' ',
                    Codeium = '󰘦 ',
                    Color = ' ',
                    Control = ' ',
                    Collapsed = ' ',
                    Constant = '󰏿 ',
                    Constructor = ' ',
                    Copilot = ' ',
                    Enum = ' ',
                    EnumMember = ' ',
                    Event = ' ',
                    Field = ' ',
                    File = ' ',
                    Folder = ' ',
                    Function = '󰊕 ',
                    Interface = ' ',
                    Key = ' ',
                    Keyword = ' ',
                    Method = '󰆧 ',
                    Module = ' ',
                    Namespace = '󰦮 ',
                    Null = ' ',
                    Number = '󰎠 ',
                    Object = ' ',
                    Operator = ' ',
                    Package = ' ',
                    Property = ' ',
                    Reference = ' ',
                    Snippet = ' ',
                    String = ' ',
                    Struct = '󰆼 ',
                    TabNine = '󰏚 ',
                    Text = ' ',
                    TypeParameter = ' ',
                    Unit = ' ',
                    Value = ' ',
                    Variable = '󰀫 ',
                  }

                  -- default kind icon
                  local icon = kind_icons[ctx.kind_icon] or ctx.kind_icon
                  -- if LSP source, check for color derived from documentation
                  if ctx.item.source_name == 'LSP' then
                    local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                    if color_item and color_item.abbr ~= '' then
                      icon = color_item.abbr
                    end
                  end
                  return icon
                end,
                highlight = function(ctx)
                  -- default highlight group
                  local highlight = 'BlinkCmpKind' .. ctx.kind
                  -- if LSP source, check for color derived from documentation
                  if ctx.item.source_name == 'LSP' then
                    local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                    if color_item and color_item.abbr_hl_group then
                      highlight = color_item.abbr_hl_group
                    end
                  end
                  return highlight
                end,
              },
            },
          },
        },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = {
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },

      snippets = {
        preset = 'luasnip',
      },

      fuzzy = {
        implementation = 'lua',
      },

      signature = {
        enabled = true,
        window = { border = 'single' },
      },
    },
  },
}
