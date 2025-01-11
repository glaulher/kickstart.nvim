return {
  {
    -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Function to combine groups for statusline
      local function combine_groups(groups)
        local result = {}
        for _, group in ipairs(groups) do
          if group.hl and group.strings then
            table.insert(result, '%#' .. group.hl .. '#')
            table.insert(result, table.concat(group.strings, ''))
          else
            table.insert(result, group)
          end
        end
        return table.concat(result, '')
      end

      -- Helper function to create color highlights
      local make_color = function(hl_fg, hl_bg)
        local fghl = vim.api.nvim_get_hl(0, { name = hl_fg })
        local bghl = vim.api.nvim_get_hl(0, { name = hl_bg })

        if fghl and bghl then
          vim.api.nvim_set_hl(0, hl_fg .. '2', {
            fg = fghl.bg,
            bg = bghl.bg,
            force = true,
          })
        else
          vim.notify('Highlight groups ' .. hl_fg .. ' or ' .. hl_bg .. ' not found.', vim.log.levels.WARN)
        end
      end

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup {

        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 50 }
            local git = MiniStatusline.section_git { trunc_width = 40 }
            local diff = MiniStatusline.section_diff { trunc_width = 75 }
            local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
            local lsp = MiniStatusline.section_lsp { trunc_width = 120 }
            local filename = MiniStatusline.section_filename { trunc_width = 120 }
            local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 100 }
            local location = MiniStatusline.section_location { trunc_width = 75 }
            local search = MiniStatusline.section_searchcount { trunc_width = 75 }

            -- Get the current buffer number
            local bufnr = vim.api.nvim_get_current_buf()
            -- Get loaded LSP clients
            local lsp_clients = vim.lsp.get_clients { bufnr = bufnr }
            local lsp_names = {}
            for _, client in ipairs(lsp_clients) do
              table.insert(lsp_names, client.name)
            end

            make_color(mode_hl, 'MiniStatuslineFilename')
            make_color('MiniStatuslineDevinfo', 'MiniStatuslineFilename')
            make_color('MiniStatuslineFileInfo', 'MiniStatuslineFilename')

            local tab = {
              { hl = mode_hl, strings = { mode } },
              { hl = mode_hl .. '2', strings = { '█ ' } },

              '%<',
            }
            if table.concat({ lsp }):len() > 0 then
              table.insert(tab, { hl = 'MiniStatuslineDevinfo2', strings = { '█' } })
              table.insert(tab, { hl = 'MiniStatuslineDevinfo', strings = { lsp .. table.concat(lsp_names, ', ') } })
              table.insert(tab, { hl = 'MiniStatuslineDevinfo2', strings = { '█ ' } })
              -- table.insert(tab, '%<')
            end

            if table.concat({ git, diff, diagnostics }):len() > 0 then
              table.insert(tab, { hl = 'MiniStatuslineDevinfo2', strings = { '█' } })
              table.insert(tab, { hl = 'MiniStatuslineDevinfo', strings = { git, ' ', diff, diagnostics } })
              table.insert(tab, { hl = 'MiniStatuslineDevinfo2', strings = { '█' } })
              table.insert(tab, '%<')
            end

            table.insert(tab, { hl = 'MiniStatuslineFilename', strings = { ' ', filename, ' ' } })
            table.insert(tab, '%=')

            if fileinfo:len() > 0 then
              table.insert(tab, { hl = 'MiniStatuslineFileinfo2', strings = { '█' } })
              table.insert(tab, { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } })
              table.insert(tab, { hl = 'MiniStatuslineFileinfo2', strings = { '█ ' } })
              table.insert(tab, '%<')
            end

            table.insert(tab, { hl = mode_hl .. '2', strings = { '█' } })
            table.insert(tab, { hl = mode_hl, strings = { search, location } })
            return combine_groups(tab)
          end,
          inactive = nil,
        },
        set_vim_settings = true,
      }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
