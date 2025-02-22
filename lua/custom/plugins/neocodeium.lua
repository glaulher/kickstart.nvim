local status, neocodeium = pcall(require, 'neocodeium')
if not status then
  return
end

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

  -- update state events
  update = {
    'User',
    pattern = { 'NeoCodeiumServer*', 'NeoCodeium*{En,Dis}abled' },
    callback = function()
      vim.cmd.redrawstatus()
    end,
  },

  -- Provider status
  provider = function(self)
    local symbols = self.symbols
    local status_provider, server_status = neocodeium.get_status()
    return symbols.status[status_provider] .. symbols.server_status[server_status]
  end,

  -- highlight
  hl = { fg = 'yellow' },
}

-- Map key accept sugestion
vim.keymap.set('i', '<A-a>', neocodeium.accept)

return {}
