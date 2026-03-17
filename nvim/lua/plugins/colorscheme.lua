return {
  -- Override the default LazyVim colorscheme plugin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false, -- Load immediately so colorscheme applies at startup
    priority = 1000, -- Load before almost everything else
    opts = {
      flavour = "mocha", -- dark variant you want (options: latte, frappe, macchiato, mocha)
      transparent_background = false, -- change to true if you want full transparency
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = true,
        which_key = true,
        -- add any other integrations you use (full list: https://github.com/catppuccin/nvim#integrations)
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Ensure LazyVim knows to use this as the main colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
