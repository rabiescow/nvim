return {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = {
        "rafamadriz/friendly-snippets", "xzbdmw/colorful-menu.nvim",
        "niuiic/blink-cmp-rg.nvim", "L3MON4D3/LuaSnip", "echasnovski/mini.icons"
    },
    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
            preset = "none",
            ["<Tab>"] = {"select_next", "fallback"},
            ["<S-Tab>"] = {"select_prev", "fallback"},
            ["<S-Enter>"] = {"accept"}
        },

        cmdline = {
            keymap = {
                preset = "none",
                ["<Tab>"] = {"select_next", "fallback"},
                ["<S-Tab>"] = {"select_prev", "fallback"},
                ["<S-Enter>"] = {"accept"}
            },
            completion = {
                menu = {auto_show = true},
                ghost_text = {enabled = false}
            }
        },

        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono'
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = {
            menu = {
                border = "rounded",
                winhighlight = "Normal:None,FloatBorder:BlinkCmpDocBorder,CursorLine:CursorLine,Search:None",
                draw = {
                    columns = {{"kind_icon"}, {"label", gap = 1}},
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local kind_icon, _, _ =
                                    require("mini.icons").get("lsp", ctx.kind)
                                return kind_icon
                            end,
                            highlight = function(ctx)
                                local _, hl, _ =
                                    require("mini.icons").get("lsp", ctx.kind)
                                return hl
                            end
                        },
                        label = {
                            text = function(ctx)
                                return
                                    require("colorful-menu").blink_components_text(
                                        ctx)
                            end,
                            highlight = function(ctx)
                                return
                                    require("colorful-menu").blink_components_highlight(
                                        ctx)
                            end
                        }
                    }
                }
            },
            accept = {auto_brackets = {enabled = false}},
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 50,
                window = {border = "rounded"}
            }
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = {"lsp", "snippets", "path", "buffer"},
            providers = {
                path = {
                    name = "Path",
                    module = "blink.cmp.sources.path",
                    score_offset = 4
                },
                lsp = {
                    name = "LSP",
                    module = "blink.cmp.sources.lsp",
                    score_offset = 3,
                    transform_items = function(_, items)
                        if vim.bo.filetype ~= "vue" then
                            return items
                        end

                        local new_items = {}
                        for _, item in ipairs(items) do
                            local is_err = item.textEdit and
                                               item.insertTextFormat ~=
                                               vim.lsp.protocol.InsertTextFormat
                                                   .Snippet and
                                               string.find(
                                                   item.textEdit.newText, "%$%d")
                            if not is_err then
                                table.insert(new_items, item)
                            end
                        end
                        return new_items
                    end
                },
                snippets = {
                    name = "Snippets",
                    module = "blink.cmp.sources.snippets",
                    score_offset = 0,
                    opts = {
                        get_filetype = function()
                            local filetype = vim.bo.filetype

                            if filetype == "vue" then
                                local node = vim.treesitter.get_node()
                                while node do
                                    if string.find(node:sexpr(),
                                                   "(script_element", 1, true) ==
                                        1 then
                                        return "typescript"
                                    elseif string.find(node:sexpr(),
                                                       "(template_element", 1,
                                                       true) == 1 then
                                        return "html"
                                    elseif string.find(node:sexpr(),
                                                       "(style_element", 1, true) ==
                                        1 then
                                        return "scss"
                                    end

                                    node = node:parent()
                                end
                            end

                            return filetype
                        end
                    }
                },
                -- ripgrep = {
                --     name = "Ripgrep",
                --     module = "blink-cmp-rg",
                --     score_offset = 2
                -- },
                buffer = {
                    name = "Buffer",
                    module = "blink.cmp.sources.buffer",
                    score_offset = 1
                }
            }
        },
        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information

        fuzzy = {
            prebuilt_binaries = {
                download = false,
                ignore_version_mismatch = true
            },
            sorts = {"score"}
        },

        signature = {
            enabled = true,
            window = {
                border = "rounded",
                winhighlight = "Normal:None,FloatBorder:BlinkCmpDocBorder"
            }
        }
    },
    opts_extend = {"sources.default"}
}
