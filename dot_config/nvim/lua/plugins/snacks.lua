return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = {
            hidden = true,
            ignored = true,
          },
          grep = {
            hidden = false,
            ignored = false,
          },
          explorer = {
            hidden = true,
            ignored = true,
            include = { ".env", ".env.*", ".next" },
          },
        },
      },
    },
  },
}
