-- lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {  -- 或 pyright，如果你還用它
          -- 強制關 single file mode（如果支援），但重點在 root_dir
          single_file_support = false,
          root_dir = function(fname)
            local util = require("lspconfig.util")
            -- 優先找 pyrightconfig.json（你的 config 最重要）
            local config_root = util.root_pattern("pyrightconfig.json")(fname)
            if config_root then return config_root end

            -- 再找其他標準 markers
            local standard_root = util.root_pattern(
              "pyproject.toml",
              "setup.py",
              "setup.cfg",
              "requirements.txt",
              ".git",
              "Cargo.toml"  -- 如果有 Rust 子專案
            )(fname)
            if standard_root then return standard_root end

            -- 最終 fallback：用當前檔案的目錄，或全域 cwd（nvrh open 後會是你的 RmLab 路徑）
            return util.path.dirname(fname) or vim.fn.getcwd()
          end,
          settings = {
            basedpyright = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",  -- 強制 workspace（跨檔 diagnostics + definition）
                typeCheckingMode = "standard",
              },
            },
          },
          -- 額外：強制 workspace diagnostics
          on_init = function(client)
            client.config.settings.analysis.diagnosticMode = "workspace"
          end,
        },
      },
    },
  },
}
