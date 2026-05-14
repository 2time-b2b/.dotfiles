local autocmd = vim.api.nvim_create_autocmd
local virtual_lines_enabled = false

vim.diagnostic.config({
  virtual_lines = false,
})

autocmd('LspAttach', {
  callback = function(e)
    local opts = { buffer = e.buf, remap = false }
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
    end

    -- GoTo code navigation.
    map('n', "gd", function() vim.lsp.buf.definition() end, "Go to definition")
    map('n', "gy", function() vim.lsp.buf.type_definition() end, "Go to type definition")
    map('n', "gi", function() vim.lsp.buf.implementation() end, "Go to implementation")
    map('n', "gr", function() vim.lsp.buf.references() end, "Go to references")

    -- Use K to show documentation in preview window.
    map('n', 'K', function() vim.lsp.buf.hover({ border = "rounded" }) end, "Show documentation")

    -- Formatting selected code.
    map({ 'n', 'v' }, "<leader>f", function() vim.lsp.buf.format() end, "Format buffer")

    -- Symbol renaming.
    map('n', "<leader>rn", function() vim.lsp.buf.rename() end, "Rename symbol")

    map('n', "<leader>vd", function() vim.diagnostic.open_float({ border = "rounded", scope = "cursor" }) end,
      "Show line diagnostics")
    map('n', "<leader>vl", function()
      virtual_lines_enabled = not virtual_lines_enabled
      vim.diagnostic.config({
        virtual_lines = virtual_lines_enabled and { current_line = true } or false,
      })
    end, "Toggle diagnostic virtual lines")
    map('n', "[d", function() vim.diagnostic.goto_prev({ float = { border = "rounded" } }) end, "Previous diagnostic")
    map('n', "]d", function() vim.diagnostic.goto_next({ float = { border = "rounded" } }) end, "Next diagnostic")
    map('i', "<C-h>", function() vim.lsp.buf.signature_help() end, "Signature help")


    -- Code Actions
    -- Display pending actions list in the current line.
    map('n', "<leader>ca", function() vim.lsp.buf.code_action() end, "Code action")

    -- Apply AutoFix to problem on the current line.
    map('n', "<leader>qf", function()
      vim.lsp.buf.code_action({
        filter = function(a) return a.isPreferred end,
        apply = true
      })
    end, "Apply preferred quick fix")
  end
})

vim.api.nvim_create_augroup("SymbolHighlightOnHover", {});
autocmd({ "CursorHold", "CursorHoldI" }, {
  group = "SymbolHighlightOnHover",
  command = "lua vim.lsp.buf.document_highlight()",
  desc = "Highlight symbol under cursor"
})

autocmd({ "CursorMoved", "CursorMovedI" }, {
  group = "SymbolHighlightOnHover",
  command = "lua vim.lsp.buf.clear_references()",
  desc = "Remove highlights for all symbol after the cursor moves."
})
