return {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    -- config = true,
    config = function()
      require("flutter-tools").setup {
          -- your config here
          lsp = {
              settings = {
                  showtodos = true,
                  completefunctioncalls = true,
              },
          },
          debugger = {
              enabled = true,
              run_via_dap = true,
          },
          widget_guides = {
              enabled = true,
          },
      }
  end,
}
