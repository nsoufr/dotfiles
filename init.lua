if vim.loader then
  vim.loader.enable()
end

_G.dd = function(...)
  require("util.debug").dump(...)
end
vim.print = _G.dd

vim.cmd("colorscheme kanagawa")

require("nvim.lazy")
