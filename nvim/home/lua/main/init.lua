require("main.set")
require("main.remap")
require("main.lazy")

os.execute("touch $HOME/.config/nvim/lua/main/lazy/local.lua")

-- Do not duplicate comments for [Return] and 'O'.
vim.cmd("autocmd BufEnter * set formatoptions-=ro")

