return {
  {
    "tpope/vim-markdown",
    config = function()
      -- tpope/vim-markdown
      vim.g.markdown_syntax_conceal = 0
      vim.g.markdown_fenced_languages = {
        "html",
        "python",
        "bash=sh",
        "json",
        "java",
        "js=javascript",
        "sql",
        "yaml",
        "xml",
        "Dockerfile",
        "Rust",
        "swift",
        "javascript",
        "lua",
      }
    end,
  }, --> syntax highlighting and filetype plugins for Markdown
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
      vim.g.mkdp_theme = "dark"
    end,
  }, -- render in broswer
  -- if not working
  -- cd ~/.local/share/nvim/lazy/markdown-preview.nvim
  -- npm install
  {
      "OXY2DEV/markview.nvim",
      lazy = false,

      -- Completion for `blink.cmp`
      -- dependencies = { "saghen/blink.cmp" },
  },
  {
    "bullets-vim/bullets.vim",
    config = function()
      vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit", "scratch" }
    end,
  },
  {
    "tenxsoydev/vim-markdown-checkswitch",
    config = function()
      vim.g.md_checkswitch_style = "cycle"
    end,
  },
  {
    "dhruvasagar/vim-table-mode",
    config = function()
      vim.cmd(
        [[
        augroup markdown_config
          autocmd!
          autocmd FileType markdown nnoremap <buffer> <M-s> :TableModeRealign<CR>
        augroup END
      ]],
        false
      )
      vim.g.table_mode_sort_map = "<leader>mts"
    end,
  }, --> table mode
}
