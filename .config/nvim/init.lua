-- The mapleader has to be one of the first things to be set
-- To be sure they are defined first I will define them here
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require("options")
require("keymaps")

-- Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- To install a new plugin, add it under lua/plugins directory
require("lazy").setup("plugins")

