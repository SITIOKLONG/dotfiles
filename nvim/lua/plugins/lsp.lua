return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- 1. 基於 Basedpyright 的靜態分析與跳轉
        basedpyright = {
          single_file_support = false,
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("pyrightconfig.json", "pyproject.toml", ".git")(fname) 
                   or util.path.dirname(fname)
          end,
          settings = {
            basedpyright = {
              analysis = {
                diagnosticMode = "workspace",
                typeCheckingMode = "standard",
              },
            },
          },
        },
        -- 2. 基於 Pylsp 的代碼風格檢查 (pycodestyle)
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = {
                  enabled = true,
                  maxLineLength = 120,
                  ignore = { 'E501', 'E231' },
                },
                -- 建議關閉其餘重複功能，只留 pycodestyle
                pyflakes = { enabled = false },
                mccabe = { enabled = false },
              },
            },
          },
        },
      },
    },
  },
}
