return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" }, -- optional: lazy-load on write
	opts = {
		-- Tell Conform what to run for Python
		formatters_by_ft = {
			python = { "ruff_format", "ruff_organize_imports" },
			-- tell lua to search for parent directories for stylua.toml
			lua = { "stylua" },
			cmake = { "cmake_format" },
			cpp = { "uncrustify" },
		},

		-- Format *before* save, synchronously
		format_on_save = function(bufnr)
			-- Disable LSP fallback to avoid pyright/ruff-lsp trying to format
			if vim.g.conform_format_on_save == false then
				return nil
			end
			return { lsp_fallback = false, timeout_ms = 2000 }
		end,

		notify_on_error = true,
	},
	keys = {
		-- toggle to enable/disable format on save
		{
			"<leader>tf",
			function()
				local current = vim.g.conform_format_on_save
				vim.g.conform_format_on_save = not current
				if vim.g.conform_format_on_save then
					vim.notify("Format on save enabled", vim.log.levels.INFO)
				else
					vim.notify("Format on save disabled", vim.log.levels.INFO)
				end
			end,
			desc = "Toggle format on save",
		},
	},
}
