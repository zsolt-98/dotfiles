return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        keymap = {
          accept = "<M-l>",
          accept_line = "<M-e>",
          accept_word = "<M-w>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<M-x>",
        },
      },
      panel = { enabled = false },
    },
  },
}
