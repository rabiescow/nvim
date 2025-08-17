local filetypes = { "haskell", "lhaskell" }
local root_markers = {
	"hie.yaml",
	"stack.yaml",
	"cabal.project",
	"*.cabal",
	"package.yaml",
}

---@type vim.lsp.Config
return {
	enable = true,
	name = "hls",
	cmd = { "haskell-language-server-wrapper", "--lsp" },
	filetypes = filetypes,
	root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1]),
	root_markers = root_markers,
	log_level = vim.lsp.protocol.MessageType.Warning,
	trace = "messages",
	single_file_support = true,
	capabilities = require("utils.capabilities").complete(),
	on_attach = require("utils.attach").on,
	settings = {
		haskell = {
			checkParents = "CheckOnSave",

			checkProject = true,
			formattingProvider = "ormolu",
			maxCompletions = 40,
			plugin = {
				alternateNumberFormat = { globalOn = true },
				cabal = { globalOn = true },
				callHierarchy = { globalOn = true },
				changeTypeSignature = { globalOn = true },
				class = { codeActionsOn = true, codeLensOn = true },
				eval = {
					config = { diff = true, exception = false },
					globalOn = true,
				},
				["explicit-fields"] = { globalOn = true },
				["explicit-fixity"] = { globalOn = true },
				fourmolu = { config = { external = false } },
				gadt = { globalOn = true },
				["ghcide-code-actions-bindings"] = { globalOn = true },
				["ghcide-code-actions-fill-holes"] = { globalOn = true },
				["ghcide-code-actions-imports-exports"] = { globalOn = true },
				["ghcide-code-actions-type-signatures"] = { globalOn = true },
				["ghcide-completions"] = {
					config = { autoExtendOn = true, snippetsOn = true },
					globalOn = true,
				},
				["ghcide-hover-and-symbols"] = {
					hoverOn = true,
					symbolsOn = true,
				},
				["ghcide-type-lenses"] = {
					config = { mode = "always" },
					globalOn = true,
				},
				hlint = {
					codeActionsOn = true,
					config = { flags = {} },
					diagnosticsOn = true,
				},
				importLens = { codeActionsOn = true, codeLensOn = true },
				moduleName = { globalOn = true },
				pragmas = { codeActionsOn = true, completionOn = true },
				qualifyImportedNames = { globalOn = true },
				refineImports = { codeActionsOn = true, codeLensOn = true },
				rename = { config = { crossModule = false }, globalOn = true },
				retrie = { globalOn = true },
				splice = { globalOn = true },
			},
		},
	},
}
