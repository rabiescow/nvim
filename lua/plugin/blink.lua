return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"xzbdmw/colorful-menu.nvim",
		"niuiic/blink-cmp-rg.nvim",
		-- LuaSnip has it's own config file
		-- {
		-- 	"L3MON4D3/LuaSnip",
		-- 	lazy = false,
		-- 	dependencies = { "kmarius/jsregexp" },
		-- 	-- tag = "v2.*",
		-- 	build = "make install_jsregexp",
		-- },
		"echasnovski/mini.icons",
	},
	version = "1.*",
	build = "cargo build --release",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "none",
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<S-Enter>"] = { "accept" },
		},

		appearance = {
			highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "mono",
			kind_icons = {
				Text = "󰉿",
				Method = "󰊕",
				Function = "󰊕",
				Constructor = "󰒓",
				Field = "󰜢",
				Variable = "󰆦",
				Property = "󰖷",
				Class = "󱡠",
				Interface = "󱡠",
				Struct = "󱡠",
				Module = "󰅩",
				Unit = "󰪚",
				Value = "󰦨",
				Enum = "󰦨",
				EnumMember = "󰦨",
				Keyword = "󰻾",
				Constant = "󰏿",
				Snippet = "󱄽",
				Color = "󰏘",
				File = "󰈔",
				Reference = "󰬲",
				Folder = "󰉋",
				Event = "󱐋",
				Operator = "󰪚",
				TypeParameter = "󰬛",
			},
		},
		completion = {
			menu = {
				enabled = true,
				min_width = 20,
				max_height = 14,
				border = "rounded",
				winblend = 0,
				winhighlight = "Normal:None,FloatBorder:BlinkCmpDocBorder,CursorLine:CursorLine,Search:None",
				scrolloff = 2,
				scrollbar = true,
				direction_priority = { "s", "n" },
				auto_show = true,
				draw = {
					align_to = "label",
					padding = 1,
					gap = 2,
					cursorline_priority = 16000,
					treesitter = { "lsp" },
					columns = { { "kind_icon", gap = 1 }, { "label", gap = 3 } },
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
								return kind_icon
							end,
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
						kind = {
							ellipsis = false,
							width = { fill = true },
							text = function(ctx)
								return ctx.kind
							end,
							highlight = function(ctx)
								return ctx.kind_hl
							end,
						},
						label = {
							width = { fill = true, min = 10, max = 40 },
							text = function(ctx)
								return ctx.label .. ctx.label_detail
							end,
							highlight = function(ctx)
								local highlights = {
									{
										0,
										#ctx.label,
										group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
									},
								}
								if ctx.label_detail then
									table.insert(
										highlights,
										{ #ctx.label, #ctx.label .. ctx.label_detail, group = "BlinkCmpLabelDetail" }
									)
								end
								for _, idx in ipairs(ctx.label_matched_indices) do
									table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
								end
								return highlights
							end,
							label_description = {
								width = { max = 30 },
								text = function(ctx)
									return ctx.label_description
								end,
								highlight = "BlinkCmpLabelDescription",
							},
							source_name = {
								width = { max = 30 },
								text = function(ctx)
									return ctx.source_name
								end,
								highlight = "BlinkCmpSource",
							},
							source_id = {
								width = { max = 30 },
								text = function(ctx)
									return ctx.source_id
								end,
								highlight = "BlinkCmpSource",
							},
						},
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				update_delay_ms = 50,
				treesitter_highlighting = true,
				draw = function(opts)
					opts = opts.default_implementation()
				end,
				window = {
					min_width = 10,
					max_width = 80,
					max_height = 20,
					border = "rounded",
					winblend = 0,
					winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
					scrollbar = true,
					direction_priority = {
						menu_north = { "e", "w", "n", "s" },
						menu_south = { "e", "w", "s", "n" },
					},
				},
			},
			ghost_text = {
				enabled = true,
				show_with_selection = true,
				show_without_selection = true,
				show_with_menu = true,
				show_without_menu = true,
			},
			list = {
				max_items = 20,
				selection = {
					preselect = true,
					auto_insert = true,
				},
				cycle = {
					from_bottom = false,
					from_top = true,
				},
			},
			accept = {
				dot_repeat = true,
				create_undo_point = true,
				resolve_timeout = 100,
				auto_brackets = {
					enabled = false,
					default_brackets = { "(", ")" },
				},
				override_brackets_for_filetypes = {},
				kind_resolution = {
					enabled = true,
					blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
				},
				semantic_token_resolution = {
					enabled = true,
					blocked_filetypes = { "java" },
					timeout_ms = 400,
				},
			},
			keyword = {
				range = "prefix",
			},
			trigger = {
				prefetch_on_insert = true,
				show_in_snippet = true,
				show_on_backspace = false,
				show_on_backspace_in_keyword = false,
				show_on_backspace_after_accept = true,
				show_on_backspace_after_insert_enter = true,
				show_on_keyword = true,
				show_on_trigger_character = true,
				show_on_insert = false,
				show_on_blocked_trigger_characters = { " ", "\n", "\t" },
				show_on_accept_on_trigger_character = true,
				show_on_insert_on_trigger_character = true,
				show_on_x_blocked_trigger_characters = { "'", '"', "(" },
			},
		},
		signature = {
			enabled = true,
			trigger = {
				enabled = true,
				show_on_keyword = false,
				blocked_trigger_characters = {},
				blocked_retrigger_characters = {},
				show_on_trigger_character = true,
				show_on_insert = false,
				show_on_insert_on_trigger_character = true,
			},
			window = {
				min_width = 1,
				max_width = 100,
				max_height = 10,
				border = "rounded",
				winblend = 0,
				winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
				scrollbar = false,
				direction_priority = { "n", "s" },
				treesitter_highlighting = true,
				show_documentation = true,
			},
		},
		fuzzy = {
			implementation = "prefer_rust_with_warning",
			max_typos = function(keyword)
				return math.floor(#keyword / 4)
			end,
			use_frecency = true,
			use_proximity = true,
			use_unsafe_no_lock = false,
			sorts = {
				"exact",
				"score",
				"sort_text",
			},
			prebuilt_binaries = {
				download = true,
				ignore_version_mismatch = true,
				force_version = nil,
				force_system_triple = nil,
				extra_curl_args = {},
				proxy = {
					from_env = true,
					url = nil,
				},
			},
		},
		sources = {
			default = { "lsp", "snippets", "omni", "path", "buffer" },
			providers = {
				lsp = {
					enabled = true,
					name = "LSP",
					module = "blink.cmp.sources.lsp",
					async = true,
					timeout_ms = 2000,
					should_show_items = true,
					max_items = 30,
					min_keyword_length = 0,
					score_offset = 3,
					fallbacks = {},
					transform_items = function(_, items)
						local new_items = {}
						for _, item in ipairs(items) do
							local is_err = item.textEdit
								and item.insertTextFormat ~= vim.lsp.protocol.InsertTextFormat.Snippet
								and string.find(item.textEdit.newText, "%$%d")
							if not is_err then
								table.insert(new_items, item)
							end
						end
						return new_items
					end,
				},
				path = {
					enabled = true,
					name = "Path",
					module = "blink.cmp.sources.path",
					score_offset = 0,
					opts = {
						trailing_slash = true,
						label_trailing_slash = true,
						get_cwd = function(context)
							return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
						end,
						show_hidden_files_by_default = false,
						ignore_root_slash = false,
					},
				},
				snippets = {
					enabled = true,
					name = "Snippets",
					module = "blink.cmp.sources.snippets",
					async = true,
					timeout_ms = 2000,
					should_show_items = true,
					max_items = 30,
					min_keyword_length = 0,
					score_offset = -1,
					fallbacks = {},
					opts = {
						friendly_snippets = true,
						search_paths = { vim.fn.stdpath("config") .. "/snippets" },
						global_snippets = { "all" },
						extended_filetypes = {},
						ignored_filetypes = {},
						get_filetype = function(_)
							return vim.bo.filetype
						end,
						clipboard_register = nil,
					},
				},
				buffer = {
					name = "Buffer",
					module = "blink.cmp.sources.buffer",
					score_offset = 1,
				},
				omni = {
					name = "omni",
					module = "blink.cmp.sources.complete_func",
					score_offset = 2,
				},
			},
			per_filetype = {
				go = { inherit_defaults = true },
				rust = { inherit_defaults = true },
			},
			transform_items = function(_, items)
				return items
			end,
			min_keyword_length = 0,
		},
		cmdline = {
			enabled = true,
			keymap = { preset = "inherit" },
			sources = function()
				local type = vim.fn.getcmdtype()
				if type == ":" or type == "@" then
					return { "cmdline" }
				else
					return { "buffer" }
				end
			end,
			completion = {
				trigger = { show_on_blocked_trigger_characters = {}, show_on_x_blocked_trigger_characters = {} },
				list = { selection = { preselect = true, auto_insert = true } },
				menu = { auto_show = true },
				ghost_text = { enabled = false },
			},
		},
		term = {
			enabled = true,
			keymap = { preset = "inherit" },
			sources = {},
			completion = {
				trigger = { show_on_blocked_trigger_characters = {}, show_on_x_blocked_trigger_characters = nil },
				list = { selection = { preselect = nil, auto_insert = nil } },
				menu = { auto_show = nil },
				ghost_text = { enabled = nil },
			},
		},
	},
	opts_extend = { "sources.default" },
}
