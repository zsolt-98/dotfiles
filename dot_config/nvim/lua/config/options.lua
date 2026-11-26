-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.cmd("colorscheme monokai-ristretto")
vim.opt.swapfile = false
vim.opt.wrap = true
vim.opt.linebreak = true

-- Container (Docker's /.dockerenv, podman's /run/.containerenv): no display server, so yank to the
-- host clipboard over OSC 52. Paste returns the unnamed register; paste host text with the terminal's paste key.
if vim.uv.fs_stat("/.dockerenv") or vim.uv.fs_stat("/run/.containerenv") then
  local osc52 = require("vim.ui.clipboard.osc52")
  local function paste()
    return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
  end
  vim.g.clipboard = {
    name = "OSC 52 (copy only)",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end
