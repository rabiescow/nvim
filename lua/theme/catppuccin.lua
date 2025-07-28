return {
	"catppuccin/nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local M = require("catppuccin")
		local U = require("catppuccin.utils.colors")
		M.setup({
			flavour = "mocha", -- latte, frappe, macchiato, mocha
			background = { light = "latte", dark = "mocha" },
			transparent_background = false,
			show_end_of_buffer = false,
			term_colors = false,
			dim_inactive = { enabled = false, shade = "dark", percentage = 0.15 },
			no_italic = false,
			no_bold = false,
			no_underline = false,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			color_overrides = {},
			custom_highlights = function(colors)
				return {
					-- go
					["@import.go"] = { link = "String" },
					-- ocaml
					["@constructor.ocaml"] = { fg = colors.flamingo },
					["@punctuation.delimiter.ocaml"] = { fg = colors.flamingo },
					["@keyword.ocaml"] = {
						fg = colors.peach,
						style = { "bold", "italic" },
					},
					["@keyword.function.ocaml"] = {
						fg = colors.peach,
						bold = true,
						italic = true,
					},
					["@keyword.import.ocaml"] = { fg = colors.maroon },
					["@keyword.module.open.ocaml"] = { fg = colors.maroon },
					["@keyword.module.name.ocaml"] = { fg = colors.maroon, italic = true },
					["@keyword.type.ocaml"] = { fg = colors.pink },
					["@variable.ocaml"] = { link = "Function" },
					["@attribute.ppx.ocaml"] = { fg = colors.yellow },
					["@attribute.method.ocaml"] = { fg = colors.maroon },

					["@lsp.type.keyword.zig"] = {
						fg = colors.peach,
						bold = true,
						-- italic = true
					},
					["@lsp.typemod.struct.declaration.zig"] = {
						fg = colors.maroon,
					},
					["@lsp.typemod.variable.declaration.zig"] = {
						fg = colors.maroon,
					},
					["@lsp.typemod.function.declaration.zig"] = {
						fg = colors.blue,
						italic = true,
					},
					["@lsp.type.namespace.zig"] = {
						fg = colors.pink,
						italic = true,
					},
					["DiagnosticUnderlineError"] = {
						fg = colors.text,
						bg = U.darken(colors.red, 0.15, colors.base),
						underline = false,
						nocombine = true,
					},
					["DiagnosticUnderlineWarn"] = {
						fg = colors.text,
						bg = U.darken(colors.peach, 0.15, colors.base),
						underline = false,
						nocombine = true,
					},
					["DiagnosticUnderlineHint"] = {
						fg = colors.text,
						bg = U.darken(colors.teal, 0.15, colors.base),
						underline = false,
						nocombine = true,
					},
					["DiagnosticUnderlineInfo"] = {
						fg = colors.text,
						bg = U.darken(colors.blue, 0.15, colors.base),
						underline = false,
						nocombine = true,
					},

					["@variable.name.angelscript"] = { fg = colors.maroon },
					["@variable.binary.angelscript"] = { fg = colors.maroon },
					["@variable.module.angelscript"] = { fg = colors.subtext1, italic = true },
					["@type.builtin.angelscript"] = { fg = colors.pink },
					["@variable.angelscript"] = { fg = colors.lavender },
					["@variable.argument.angelscript"] = { fg = colors.peach },
					["@punctuation.separator.angelscript"] = { fg = colors.flamingo },

					LspCodeLens = { fg = colors.hint, bold = true, italic = true }, -- virtual text of the codelens
					LspInlayHint = { fg = colors.hint, italic = true }, -- virtual text of the inlay hints
					CursorLine = {
						bg = U.brighten(colors.crust, 0.25, colors.base),
					},

					BlinkCmpCursorLineMenuHack = { fg = colors.text, bg = colors.maroon },
					BlinkCmpCursorLineDocumentationHack = { fg = colors.text, bg = colors.maroon },

					BlinkCmpDoc = { fg = colors.green, bg = colors.mantle },
					BlinkCmpDocSelection = { fg = colors.pink, bg = colors.mantle },
					BlinkCmpDocCursorLine = { fg = colors.blue, bg = colors.mantle },
					BlinkCmpDocBorder = { fg = colors.subtext1, bg = colors.mantle },

					BlinkCmpGhostText = { fg = colors.subtext0, italic = true },

					BlinkCmpKind = { fg = colors.blue },
					BlinkCmpKindClass = { fg = colors.blue },
					BlinkCmpKindColor = { fg = colors.flamingo },
					BlinkCmpKindConstructor = { fg = colors.lavender },
					BlinkCmpKindConstant = { fg = colors.maroon },
					BlinkCmpKindCoPilot = { fg = colors.peach },
					BlinkCmpKindEnum = { fg = colors.pink },
					BlinkCmpKindEnumMember = { fg = colors.red },
					BlinkCmpKindEvent = { fg = colors.teal },
					BlinkCmpKindFolder = { fg = colors.yellow },
					BlinkCmpKindField = { fg = colors.blue },
					BlinkCmpKindFile = { fg = colors.flamingo },
					BlinkCmpKindFunction = { fg = colors.lavender },
					BlinkCmpKindInterface = { fg = colors.maroon },
					blinkCmpKindKeyword = { fg = colors.peach },
					BlinkCmpKindMethod = { fg = colors.pink },
					BlinkCmpKindModule = { fg = colors.red },
					BlinkCmpKindOperator = { fg = colors.teal },
					BlinkCmpKindProperty = { fg = colors.yellow },
					BlinkCmpKindReference = { fg = colors.blue },
					BlinkCmpKindSnippet = { fg = colors.flamingo },
					BlinkCmpKindStruct = { fg = colors.lavender },
					BlinkCmpKindText = { fg = colors.maroon },
					BlinkCmpKindTypeParameter = { fg = colors.peach },
					BlinkCmpKindUnit = { fg = colors.pink },
					BlinkCmpKindValue = { fg = colors.red },
					BlinkCmpKindVariable = { fg = colors.teal },

					BlinkCmpLabel = { fg = colors.text },
					BlinkCmpLabelDeprecated = { fg = colors.overlay0, strikethrough = true },
					BlinkCmpLabelDescription = { fg = colors.subtext0 },
					BlinkCmpLabelDetail = { fg = colors.peach },
					BlinkCmpLabelMatch = { fg = colors.peach, bold = true },

					BlinkCmpMenu = { fg = colors.blue, bg = colors.surface0 },
					BlinkCmpMenuBorder = { fg = colors.blue, bg = colors.surface0 },
					BlinkCmpMenuSelection = { fg = colors.text, italic = true, bg = colors.crust },

					BlinkCmpSource = { fg = colors.teal, bg = colors.surface0 },
					BlinkCmpScrollBarGutter = { fg = colors.teal, bg = colors.overlay2 },
					BlinkCmpScrollBarThumb = { fg = colors.teal, bg = colors.overlay2 },
					BlinkCmpSignatureHelp = { fg = colors.teal, bg = colors.mantle },
					BlinkCmpSignatureHelpActiveParameter = { fg = colors.teal, bg = colors.mantle },
					BlinkCmpSignatureHelpBorder = { fg = colors.subtext1, bg = colors.mantle },

					OilPermissionExecute = { fg = colors.red },
					OilPermissionWrite = { fg = colors.peach },
					OilPermissionRead = { fg = colors.lavender },
					OilPermissionNA = { fg = colors.subtext0 },
					OilSize = { fg = colors.text },
					OilType = { fg = colors.yellow, italic = true },
					OilMtime = { fg = colors.flamingo, italic = true },
				}
			end,
			default_integrations = true,
			integrations = {
				blink_cmp = true,
				diffview = true,
				fidget = false,
				gitsigns = true,
				indent_blankline = {
					enabled = true,
					scope_color = "surface2",
					colored_indent_levels = false,
				},
				lualine = require("lualine").setup({
					options = { theme = "catppuccin" },
				}),
				treesitter = true,
				mini = { enabled = true, indentscope_color = "" },
				native_lsp = {
					enabled = true,
					inlay_hints = { background = false },
				},
			},
		})
		return M
	end,
}
