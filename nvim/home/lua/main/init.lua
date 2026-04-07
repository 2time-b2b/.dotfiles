require("main.set")
require("main.remap")
require("main.lazy")

local local_file = vim.fn.expand("$HOME/.config/nvim/lua/main/lazy/local.lua")

local f = io.open(local_file, "r")
if f ~= nil then
  io.close(f)
else
  local new = io.open(local_file, "w")
  if new then
    new:write("return {}")
    new:close()
  end
end

-- Do not duplicate comments for [Return] and 'O'.
vim.cmd("autocmd BufEnter * set formatoptions-=ro")
