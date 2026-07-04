return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- -- import mason_lspconfig plugin
		-- local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		-- Ensure that ltex is used for txt files
		vim.lsp.config("ltex-ls", {
			filetypes = { "markdown", "text", "tex", "txt" },
			settings = {
				ltex = {
					language = "en-US",
					diagnosticSeverity = "information",
					additionalRules = {
						enablePickyRules = true,
						languageModel = "n-gram",
					},
				},
			},
		})
		vim.lsp.enable("ltex")

		vim.lsp.config("cspell-lsp", {
			filetypes = { "cpp", "c", "cmake" },
			cmd = { "cspell-lsp", "--stdio" },
			settings = {
				cspell = {
					language = "en",
					diagnostics = {
						enableFiletypes = { "cpp", "c", "cmake" },
					},
				},
			},
		})

		vim.lsp.enable("cspell-lsp")

		vim.lsp.config("cmake_language_server", {
			filetypes = { "cmake" },
		})

		vim.lsp.enable("cmake_language_server")

		-- vim.lsp.config("clangd", {
		-- 	filetypes = { "c", "cpp", "objc", "objcpp", "hpp", "hh", "hxx" },
		-- 	-- set compile-comands directory to build folder
		-- 	cmd = {
		-- 		"clangd",
		-- 		"--compile-commands-dir=build",
		-- 		"--path-mappings=/workspace/=/home/mspahn/montana/gilching_stack/MrDevelopment",
		-- 	},
		-- 	on_attach = function(client, bufnr)
		-- 		-- Disable clangd formatting so null-ls/uncrustify can take over
		-- 		client.server_capabilities.documentFormattingProvider = false
		-- 		client.server_capabilities.documentRangeFormattingProvider = false
		-- 	end,
		-- })
		vim.lsp.enable("clangd")


		-- Ruff (native LSP) throw warning on line-length 100 exceeded
		vim.lsp.config("ruff", {
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				vim.notify("Ruff LSP attached to buffer " .. bufnr, vim.log.levels.INFO)
				client.server_capabilities.documentFormattingProvider = true
				client.server_capabilities.codeActionProvider = true
			end,
		})
		vim.lsp.enable("ruff")

		-- -- Pyright with Ruff integration
		-- vim.lsp.config("pyright", {
		-- 	capabilities = capabilities,
		-- 	settings = {
		-- 		python = {
		-- 			analysis = {
		-- 				ignore = { "*" }, -- Let Ruff handle linting
		-- 			},
		-- 		},
		-- 		pyright = {
		-- 			disableOrganizeImports = true, -- Ruff handles import sorting
		-- 		},
		-- 	},
		-- })
		-- vim.lsp.enable("pyright")

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Both",
						keywordSnippet = "Both",
					},
					hint = {
						enable = true,
					},
					workspace = {
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})

		vim.lsp.enable("lua_ls")

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- do not use mason setup handlers
		-- mason_lspconfig.setup({
		-- 	ensure_installed = {
		-- 		-- "lua_ls",
		-- 		-- "pyright",
		-- 		-- "omnisharp",
		-- 		-- "ltex-ls",
		-- 		-- "cspell-lsp",
		-- 		-- "cmake_language_server",
		-- 		-- "clangd",
		-- 	},
		-- 	automatic_installation = true,
		-- })
		-- mason_lspconfig.setup_handlers({
		--   -- default handler for installed servers
		--   function(server_name)
		--     vim.lsp.config(server_name, {
		--       capabilities = capabilities,
		--     })
		--     vim.lsp.enable(server_name)
		--   end,
		--   ["lua_ls"] = function()
		--     -- configure lua server (with special settings)
		--     vim.lsp.config('lua_ls', {
		--       capabilities = capabilities,
		--       settings = {
		--         Lua = {
		--           -- make the language server recognize "vim" global
		--           diagnostics = {
		--             globals = { "vim" },
		--           },
		--           completion = {
		--             callSnippet = "Replace",
		--           },
		--         },
		--       },
		--     })
		--     vim.lsp.enable('lua_ls')
		--   end,
		--   -- Ruff (native LSP) throw warning on line-length 100 exceeded
		--   ["ruff"] = function()
		--     vim.lsp.config('ruff', {
		--       capabilities = capabilities,
		--       on_attach = function(client, bufnr)
		--         vim.notify("Ruff LSP attached to buffer " .. bufnr, vim.log.levels.INFO)
		--         client.server_capabilities.documentFormattingProvider = true
		--         client.server_capabilities.codeActionProvider = true
		--       end,
		--     })
		--     vim.lsp.enable('ruff')
		--
		--   end,
		--
		--   -- Pyright with Ruff integration
		--   ["pyright"] = function()
		--     vim.lsp.config('pyright', {
		--       capabilities = capabilities,
		--       settings = {
		--         python = {
		--           analysis = {
		--             ignore = { "*" }, -- Let Ruff handle linting
		--           },
		--         },
		--         pyright = {
		--           disableOrganizeImports = true, -- Ruff handles import sorting
		--         },
		--       },
		--     })
		--     vim.lsp.enable('pyright')
		--  end
		-- })
	end,
}
