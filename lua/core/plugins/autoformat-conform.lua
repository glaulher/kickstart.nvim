return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre', 'BufNewFile' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 5000,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list

        -- Commenting out Prettier for JavaScript and TypeScript as ESLint's configuration already handles formatting for these file types.
        -- Configuring Prettier in both places can lead to conflicts and unexpected formatting behavior.
        -- By removing these lines, we ensure that ESLint's formatting rules take precedence.

        -- javascript = { 'prettier', 'prettierd', stop_after_first = true },
        -- typescript = { 'prettier', 'prettierd', stop_after_first = true },
        -- javascriptreact = { 'prettier', 'prettierd', stop_after_first = true },
        -- typescriptreact = { 'prettier', 'prettierd', stop_after_first = true },
        svelte = { 'prettier', 'prettierd', stop_after_first = true },
        --      css = { 'prettier', 'prettierd', stop_after_first = true },
        --        html = { 'prettier', 'prettierd', stop_after_first = true },
        --        json = { 'prettier', 'prettierd', stop_after_first = true },
        yaml = { 'prettier', 'prettierd', stop_after_first = true },
        markdown = { 'prettier', 'prettierd', stop_after_first = true },
        graphql = { 'prettier', 'prettierd', stop_after_first = true },

        java = { 'sonarlint' },
      },
    },
  },
}
