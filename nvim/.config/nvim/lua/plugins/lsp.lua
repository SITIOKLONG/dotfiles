return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- 1. 基於 Basedpyright 的靜態分析與跳轉
        basedpyright = {
          mason = false,
          single_file_support = false,
          -- Neovim 0.12 calls root_dir(bufnr, on_dir); 0.11 calls root_dir(fname)
          -- and expects a string back. Support both.
          root_dir = function(fname, on_dir)
            if type(fname) == "number" then
              fname = vim.api.nvim_buf_get_name(fname)
            end
            local util = require("lspconfig.util")
            local root = util.root_pattern("pyrightconfig.json", "pyproject.toml", ".git")(fname)
              or vim.fn.fnamemodify(fname, ":p:h")
            if on_dir then
              on_dir(root)
            else
              return root
            end
          end,
          settings = {
            basedpyright = {
              analysis = {
                diagnosticMode = "workspace",
                typeCheckingMode = "standard",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        -- 2. 基於 Pylsp 的代碼風格檢查 (pycodestyle)
        pylsp = {
          mason = false,
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = {
                  enabled = true,
                  maxLineLength = 220,
                  ignore = { "E501", "E231" },
                },
                -- 建議關閉其餘重複功能，只留 pycodestyle
                pyflakes = { enabled = false },
                mccabe = { enabled = false },
                -- 跳轉/補全/hover 交給 basedpyright，避免 gd 出現重複結果
                jedi_completion = { enabled = false },
                jedi_definition = { enabled = false },
                jedi_hover = { enabled = false },
                jedi_references = { enabled = false },
                jedi_rename = { enabled = false },
                jedi_signature_help = { enabled = false },
                jedi_symbols = { enabled = false },
              },
            },
          },
        },
        matlab_ls = {
          cmd = { "matlab-language-server", "--stdio" },
          filetypes = { "matlab" },
          root_dir = require("lspconfig.util").root_pattern(".git", "*.prj", "*.prj2"),
          on_attach = function(client, bufnr)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "MATLAB Help", remap = true })
          end,
          settings = {
            matlab = {
              indexWorkspace = true, -- Start minimal, enable later
              matlabConnectionTiming = "onStart",
              prewarmGraphics = false,
              telemetry = false,
              installPath = "/Applications/MATLAB_R2025b.app",
            },
          },
          init_timeout = 180000,
        },
        -- dartls = {},
        clangd = {},
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
