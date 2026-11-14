-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

vim.keymap.set("n", "<leader>/", function()
  Snacks.picker.grep({ hidden = false, ignored = false })
end, { desc = "Grep Root Dir" })

vim.keymap.set("n", "<leader>G/", function()
  Snacks.picker.grep({ hidden = true, ignored = true })
end, { desc = "Grep Root Dir (All Files)" })

vim.keymap.set("n", "<leader><space>", function()
  Snacks.picker.files({ hidden = false, ignored = false })
end, { desc = "Find Files (Root Dir)" })

vim.keymap.set("n", "<leader>G<space>", function()
  Snacks.picker.files({ hidden = true, ignored = true })
end, { desc = "Find Files (Root Dir, All Files)" })

vim.keymap.set("n", "<leader>dy", function()
  local diags = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
  if #diags == 0 then
    return vim.notify("No diagnostics on line")
  end
  local msgs = vim.tbl_map(function(d)
    return d.message
  end, diags)
  table.insert(msgs, vim.fn.expand("%:.") .. ":" .. vim.fn.line("."))
  vim.fn.setreg("+", table.concat(msgs, "\n"))
  vim.notify("Diagnostic copied")
end, { desc = "Yank Line Diagnostics" })
