-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Force cyan cursor on enter (nvim always starts in normal, overrides zsh-vi-mode residual)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    io.write("\027]12;#85dacc\007")
    io.flush()
  end,
})

-- Sync cursor color with mode changes
vim.api.nvim_create_autocmd("ModeChanged", {
  callback = function()
    local mode = vim.fn.mode()
    if mode == "i" or mode == "R" then
      io.write("\027]12;#adda78\007")  -- green  (INSERT)
    elseif mode == "v" or mode == "V" or mode == "\022" then
      io.write("\027]12;#f9cc6c\007")  -- yellow (VISUAL)
    else
      io.write("\027]12;#85dacc\007")  -- cyan   (NORMAL)
    end
  end,
})

-- Disable spell check in prose filetypes (keeps LazyVim's soft wrap)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.spell = false
  end,
})
