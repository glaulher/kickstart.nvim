return {

  {
    --    'schrieveslaach/sonarlint.nvim',
    url = 'https://gitlab.com/schrieveslaach/sonarlint.nvim',
    config = function()
      require('sonarlint').setup {
        server = {
          cmd = {
            'sonarlint-language-server',
            -- Ensure that sonarlint-language-server uses stdio channel
            '-stdio',
            '-analyzers',
            -- paths to the analyzers you need, using those for python and java in this example
            vim.fn.expand(tostring(vim.fn.getenv 'MASON') .. '/share/sonarlint-analyzers/sonarpython.jar'),
            vim.fn.expand(tostring(vim.fn.getenv 'MASON') .. '/share/sonarlint-analyzers/sonarcfamily.jar'),
            vim.fn.expand(tostring(vim.fn.getenv 'MASON') .. '/share/sonarlint-analyzers/sonarjava.jar'),
          },
        },
        filetypes = {
          -- Tested and working
          'python',
          'cpp',
          'java',
        },
      }
      -- Autocmd to ensure SonarLint starts automatically when a Java file is opened
      -- vim.api.nvim_create_autocmd('FileType', {
      --   pattern = { 'java' },
      --   callback = function()
      --     require('sonarlint').setup {}
      --   end,
      -- })
    end,
  },
}
