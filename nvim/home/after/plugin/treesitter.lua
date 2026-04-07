local function install_parsers()
  local ensureInstalled = { "lua", "bash" }
  local alreadyInstalled = require("nvim-treesitter.config").get_installed()
  local parsersToInstall = vim.iter(ensureInstalled)
      :filter(function(parser)
        return not vim.tbl_contains(alreadyInstalled, parser)
      end)
      :totable()
  require("nvim-treesitter").install(parsersToInstall)
end

local function setup_treesitter_environment()
  -- Check if tree-sitter-cli is already installed.
  if vim.fn.executable("tree-sitter") == 1 then
    -- If present, just ensure the specified parsers are installed.
    install_parsers()
    return
  end

  print("tree-sitter-cli not found. Installing via npm ...")

  vim.system({ "npm", "install", "-g", "tree-sitter-cli" }, { text = true }, function(obj)
    -- The callback: this waits for npm to finish
    vim.schedule(function()
      if obj.code == 0 then
        print("tree-sitter-cli installed successfully!")
        install_parsers()
      else
        print("Failed to install tree-sitter-cli. Parsers will not be installed.")
        print("Error: " .. (obj.stderr or "Unknown error"))
      end
    end)
  end)
end

setup_treesitter_environment()
