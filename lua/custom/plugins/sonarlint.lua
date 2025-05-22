return {

  -- Plugin SonarLint
  --  'schrieveslaach/sonarlint.nvim',
  url = 'https://gitlab.com/schrieveslaach/sonarlint.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
  },
  opts = function()
    require('sonarlint').setup {
      server = {
        cmd = {
          'sonarlint-language-server',
          -- Ensure that sonarlint-language-server uses stdio channel
          '-stdio',
          '-analyzers',
          -- paths to the analyzers you need, adjust as necessary
          vim.fn.expand(tostring(vim.fn.getenv 'MASON') .. '/share/sonarlint-analyzers/sonarpython.jar'),
          vim.fn.expand(tostring(vim.fn.getenv 'MASON') .. '/share/sonarlint-analyzers/sonarcfamily.jar'),
          vim.fn.expand(tostring(vim.fn.getenv 'MASON') .. '/share/sonarlint-analyzers/sonarjava.jar'),
        },
      },
      filetypes = {
        --  'python',
        'cpp',
        'java',
      },
    }
  end,
}
