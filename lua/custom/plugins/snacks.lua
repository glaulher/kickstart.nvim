---@diagnostic disable: undefined-doc-name, undefined-global
-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {

  { -- Fuzzy Finder (files, lsp, etc)
    'folke/snacks.nvim',

    dependencies = {

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },

    -- snacks.nvim is a plugin that contains a collection of QoL improvements.
    -- One of those plugins is called snacks-picker
    -- It is a fuzzy finder, inspired by Telescope, that comes with a lot of different
    -- things that it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- Two important keymaps to use while in a picker are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Snacks picker. This is really useful to discover what nacks-picker can
    -- do as well as how to actually do it!

    -- [[ Configure Snacks Pickers ]]
    -- See `:help snacks-picker` and `:help snacks-picker-setup`
    ---@type snacks.Config
    opts = {
      picker = {},
      explorer = {},
      bigfile = {},
      notifier = { enabled = true },
    },

    -- See `:help snacks-pickers-sources`
    keys = {
      {
        '<leader>e',
        function()
          Snacks.explorer()
        end,
        desc = 'Snacks File Explorer',
      },

      {
        '<leader>sh',
        function()
          Snacks.picker.help()
        end,
        desc = '[S]earch [H]elp',
      },
      {
        '<leader>sk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = '[S]earch [K]eymaps',
      },
      {
        '<leader>sf',
        function()
          Snacks.picker.smart()
        end,
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>ss',
        function()
          Snacks.picker.pickers()
        end,
        desc = '[S]earch [S]elect Snacks',
      },
      {
        '<leader>sw',
        function()
          Snacks.picker.grep_word()
        end,
        desc = '[S]earch current [W]ord',
        mode = { 'n', 'x' },
      },
      {
        '<leader>sg',
        function()
          Snacks.picker.grep()
        end,
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>sd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = '[S]earch [D]iagnostics',
      },
      {
        '<leader>sr',
        function()
          Snacks.picker.resume()
        end,
        desc = '[S]earch [R]esume',
      },
      {
        '<leader>s.',
        function()
          Snacks.picker.recent()
        end,
        desc = '[S]earch Recent Files ("." for repeat)',
      },
      {
        '<leader><leader>',
        function()
          Snacks.picker.buffers()
        end,
        desc = '[ ] Find existing buffers',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.lines {}
        end,
        desc = '[/] Fuzzily search in current buffer',
      },
      {
        '<leader>s/',
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = '[S]earch [/] in Open Files',
      },
      -- Shortcut for searching your Neovim configuration files
      {
        '<leader>sn',
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = '[S]earch [N]eovim files',
      },
    },

    config = function(_, opts)
      local notify = vim.notify
      require('snacks').setup(opts)
      -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
      -- this is needed to have early notifications show up in noice history
      if pcall(require, 'noice') then
        vim.notify = notify
      end

      -- vim.api.nvim_create_autocmd('LspProgress', {
      --   ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
      --   callback = function(ev)
      --     local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
      --     vim.notify(vim.lsp.status(), 'info', {
      --       id = 'lsp_progress',
      --       title = 'LSP Progress',
      --       opts = function(notif)
      --         notif.icon = ev.data.params.value.kind == 'end' and ' ' or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      --       end,
      --     })
      --   end,
      -- })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('snacks-lsp-attach', { clear = true }),
        callback = function(event)
          -- Find references for the word under your cursor.
          vim.keymap.set('n', 'grr', require('snacks').picker.lsp_references, { buffer = event.buf, desc = '[G]oto [R]eferences' })

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          vim.keymap.set('n', 'gri', require('snacks').picker.lsp_implementations, { buffer = event.buf, desc = '[G]oto [I]mplementation' })

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          vim.keymap.set('n', 'grd', require('snacks').picker.lsp_definitions, { buffer = event.buf, desc = '[G]oto [D]efinition' })

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          vim.keymap.set('n', 'gO', require('snacks').picker.lsp_symbols, { buffer = event.buf, desc = 'Open Document Symbols' })

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          vim.keymap.set('n', 'gW', require('snacks').picker.lsp_workspace_symbols, { buffer = event.buf, desc = 'Open Workspace Symbols' })

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          vim.keymap.set('n', 'grt', require('snacks').picker.lsp_type_definitions, { buffer = event.buf, desc = '[G]oto [T]ype Definition' })
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
