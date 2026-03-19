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
                   or util.fs.dirname(fname)
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
                  maxLineLength = 220,
                  ignore = { 'E501', 'E231' },
                },
                -- 建議關閉其餘重複功能，只留 pycodestyle
                pyflakes = { enabled = false },
                mccabe = { enabled = false },
              },
            },
          },
        },
        matlab_ls = {
          cmd = { "matlab-language-server", "--stdio" },
          filetypes = { "matlab" },
          root_dir = require("lspconfig.util").root_pattern(".git", "*.prj", "*.prj2"),
          on_attach = function(client, bufnr)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "MATLAB Help", remap = true})
          end,
          settings = {
            matlab = {
              indexWorkspace = true,  -- Start minimal, enable later
              matlabConnectionTiming = "onStart",
              prewarmGraphics = false,
              telemetry = false,
              installPath = "/Applications/MATLAB_R2025b.app",
            },
          },
          init_timeout = 180000,
        },
        -- dartls = {},
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "matlab" })
      end
    end,
  },
}
