return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      indent = {
        highlight = {
          'RainbowRed',
          'RainbowYellow',
          'RainbowBlue',
          'RainbowOrange',
          'RainbowGreen',
          'RainbowViolet',
          'RainbowCyan',
        },
      },
    },
    config = function()
      -- Define as cores dos grupos de destaque (highlight)
      local hooks = require 'ibl.hooks'
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
        vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
        vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
        vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
      end)

      -- Setup do plugin
      require('ibl').setup {
        indent = {
          highlight = {
            'RainbowRed',
            'RainbowYellow',
            'RainbowBlue',
            'RainbowOrange',
            'RainbowGreen',
            'RainbowViolet',
            'RainbowCyan',
          },
        },
      }
    end,
  },
}
