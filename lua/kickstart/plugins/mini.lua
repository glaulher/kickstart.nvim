return {
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()

      local function combine_groups(groups)
        local result = {}
        for _, group in ipairs(groups) do
          if type(group) == 'table' and group.hl and group.strings then
            table.insert(result, '%#' .. group.hl .. '#')
            table.insert(result, table.concat(group.strings, ''))
          else
            table.insert(result, group)
          end
        end
        return table.concat(result, '')
      end

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

      local function get_project_root()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients { bufnr = bufnr }
        for _, client in ipairs(clients) do
          local workspace_folders = client.config.workspace_folders
          if workspace_folders and #workspace_folders > 0 then
            local uri = workspace_folders[1].uri or workspace_folders[1]
            local path = vim.uri_to_fname(uri)
            return vim.fn.fnamemodify(path, ':p')
          end
          if client.config.root_dir then
            return vim.fn.fnamemodify(client.config.root_dir, ':p')
          end
        end

        local handle = io.popen 'git rev-parse --show-toplevel 2> /dev/null'
        if handle then
          local result = handle:read '*a'
          handle:close()
          result = vim.trim(result)
          if result ~= '' then
            return vim.fn.fnamemodify(result, ':p')
          end
        end

        return vim.fn.getcwd()
      end

      local statusline = require 'mini.statusline'

      statusline.setup {
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 50 }
            local git = MiniStatusline.section_git { trunc_width = 40 }
            local diff = MiniStatusline.section_diff { trunc_width = 75 }
            local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
            local lsp = MiniStatusline.section_lsp { trunc_width = 120 }
            local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 100 }
            local location = string.format('%2d:%-2d', vim.fn.line '.', vim.fn.col '.')
            local search = MiniStatusline.section_searchcount { trunc_width = 75 }

            local root = vim.fn.fnamemodify(get_project_root(), ':p'):gsub('/$', '')
            local full_path = vim.fn.expand '%:p'
            local display_path = ''
            local project_name = vim.fn.fnamemodify(root, ':t')

            if full_path == '' then
              display_path = project_name .. '/[No Name]'
            elseif full_path:sub(1, #root) == root then
              local relative_path = full_path:sub(#root + 2)
              if relative_path == '' then
                display_path = project_name .. '/[No Name]'
              else
                display_path = project_name .. '/' .. relative_path
              end
            else
              display_path = vim.fn.fnamemodify(full_path, ':.')
            end

            local bufnr = vim.api.nvim_get_current_buf()
            local lsp_clients = vim.lsp.get_clients { bufnr = bufnr }
            local lsp_names = {}
            for _, client in ipairs(lsp_clients) do
              table.insert(lsp_names, client.name)
            end

            make_color(mode_hl, 'MiniStatuslineFilename')
            make_color('MiniStatuslineDevinfo', 'MiniStatuslineFilename')
            make_color('MiniStatuslineFileinfo', 'MiniStatuslineFilename')

            local tab = {
              { hl = mode_hl, strings = { mode } },
              { hl = mode_hl .. '2', strings = { '█ ' } },
              '%<',
            }

            if lsp ~= '' or #lsp_names > 0 then
              local combined = lsp
              if #lsp_names > 0 then
                combined = combined .. (lsp ~= '' and ' ' or '') .. table.concat(lsp_names, ', ')
              end
              table.insert(tab, { hl = 'MiniStatuslineDevinfo2', strings = { '█' } })
              table.insert(tab, { hl = 'MiniStatuslineDevinfo', strings = { combined } })
              table.insert(tab, { hl = 'MiniStatuslineDevinfo2', strings = { '█ ' } })
            end

            if (git .. diff .. diagnostics):len() > 0 then
              table.insert(tab, { hl = 'MiniStatuslineDevinfo2', strings = { '█' } })
              table.insert(tab, { hl = 'MiniStatuslineDevinfo', strings = { git, ' ', diff, ' ', diagnostics } })
              table.insert(tab, { hl = 'MiniStatuslineDevinfo2', strings = { '█' } })
              table.insert(tab, '%<')
            end

            table.insert(tab, { hl = 'MiniStatuslineFilename', strings = { ' ', display_path, ' ' } })
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
    end,
  },
}
