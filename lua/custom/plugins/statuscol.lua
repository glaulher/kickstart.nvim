local status, statuscol = pcall(require, 'statuscol')
if not status then
  return
end

local builtin = require 'statuscol.builtin'

statuscol.setup {
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

return {}
