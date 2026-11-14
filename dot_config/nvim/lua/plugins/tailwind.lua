return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {},
      },
    },
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      options = {
        parsers = {
          tailwind = {
            enable = true,
            lsp = false,
          },
          css = { oklch = true },
        },
        display = {
          disable_document_color = false,
        },
      },
    },
  },
}
