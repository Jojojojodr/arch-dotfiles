return {
  -- Example: Bind theme switching to <leader>tt using Themery
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        themes = { "catppuccin", "tokyonight", "gruvbox", "vscode", "bluloco" },
        livePreview = true,
      })
      vim.keymap.set("n", "<leader>tt", ":Themery<CR>", { desc = "Open Theme Picker" })
    end,
  },
}   