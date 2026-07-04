return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")

    local on_attach = function(client, bufnr)
      vim.notify("none-ls attached to buffer " .. bufnr, vim.log.levels.INFO)

      if client.supports_method("textDocument/formatting") then
        local group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
        vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = group,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end
    end

    null_ls.setup({
      sources = {
        -- null_ls.builtins.formatting.black.with({ extra_args = { "--line-length", "100" } }),
        -- null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.ruff,
        -- null_ls.builtins.formatting.ruff_organize_imports,
        -- null_ls.builtins.code_actions.ruff,
        null_ls.builtins.diagnostics.mypy,
        -- use cspell
        -- null_ls.builtins.diagnostics.builtins.cspell.with({
        --   filetypes = { "cpp", "cmake" },
        -- }),
        -- null_ls.builtins.diagnostics.cppcheck.with({
        --   extra_args = { "--enable=all", "--inconclusive", "--std=c++20" },
        -- }),
        -- null_ls.builtins.formatting.clang_format,
        -- null_ls.builtins.formatting.uncrustify.with({
        --   to_stdin = false,
        --   command = "uncrustify",
        --   args = function(params)
        --       return {
        --           "--config",
        --           vim.fn.expand("~/.config/uncrustify/uncrustify.cfg"),
        --           "-f", params.bufname,  -- feed file directly
        --           "--no-backup",
        --       }
        --   end,
        --
        --   -- Tell null-ls that output goes to stdout (like your CLI redirect)
        --   on_output = function(line, done)
        --       -- Uncrustify prints the formatted buffer to stdout,
        --       -- so null-ls can apply it directly.
        --       done({ text = line })
        --   end,
        -- }),
        null_ls.builtins.formatting.cmake_format,
        -- null_ls.builtins.diagnostics.clang_check,
      },
      on_attach = on_attach,
    })

    vim.api.nvim_set_keymap('n', '<leader>ff', ':lua vim.lsp.buf.format({ async = true })<CR>',
      { noremap = true, silent = false })
    -- keybinding to automatically fix issues on save buffer, exclude cpp/hpp files.
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.py",
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end,
}
