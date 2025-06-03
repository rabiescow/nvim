local default_snippets = [[ {
  "Ok": {
    "postfix": "ok",
    "body": "Ok(${receiver})",
    "description": "Wrap the expression in a `Result::Ok`",
    "scope": "expr"
  },
  "Box::pin": {
    "postfix": "pinbox",
    "body": "Box::pin(${receiver})",
    "requires": "std::boxed::Box",
    "description": "Put the expression into a pinned `Box`",
    "scope": "expr"
  },
  "Arc::new": {
    "postfix": "arc",
    "body": "Arc::new(${receiver})",
    "requires": "std::sync::Arc",
    "description": "Put the expression into an `Arc`",
    "scope": "expr"
  },
  "Some": {
    "postfix": "some",
    "body": "Some(${receiver})",
    "description": "Wrap the expression in an `Option::Some`",
    "scope": "expr"
  },
  "Err": {
    "postfix": "err",
    "body": "Err(${receiver})",
    "description": "Wrap the expression in a `Result::Err`",
    "scope": "expr"
  },
  "Rc::new": {
    "postfix": "rc",
    "body": "Rc::new(${receiver})",
    "requires": "std::rc::Rc",
    "description": "Put the expression into an `Rc`",
    "scope": "expr"
  }
} ]]

return {
    cmd = {'rust-analyzer'},
    filetypes = {'rust'},
    root_markers = {'Cargo.toml', 'rust-project.json'},
    settings = {
        ["rust-analyzer"] = {
            assist = {
                emitMustUse = false,
                expressionFillDefault = "todo",
                termSearch = {borrowcheck = true, fuel = 1800}
            },
            cachePriming = {enable = true, numThreads = "physical"},
            cargo = {
                allTargets = true,
                autoreload = true,
                buildScripts = {
                    enable = true,
                    invocationStrategy = "per_workspace",
                    overrideCommand = nil,
                    rebuildOnSave = true,
                    useRustcWrapper = true
                },
                cfgs = {"debug_assertions", "miri"},
                extraArgs = {},
                extraEnv = nil,
                features = "all",
                noDefaultFeatures = false,
                noDeps = false,
                sysroot = "discover",
                sysrootSrc = nil,
                target = nil,
                targetDir = true,
                setTest = true
            },
            checkOnSave = true,
            check = {
                allTargets = true,
                command = "check",
                extraArgs = {},
                extraEnv = nil,
                features = nil,
                ignore = {},
                invocationStrategy = "per_workspace",
                noDefaultFeatures = nil,
                overrideCommand = {},
                targets = nil,
                workspace = true
            },
            completion = {
                addSemicolonToUnit = true,
                autoAwait = {enable = true},
                autoIter = {enable = true},
                autoimport = {
                    enable = true,
                    exclude = {
                        {path = "core::borrow::Borrow", type = "methods"},
                        {path = "core::borrow::BorrowMut", type = "methods"}
                    }
                },
                autoself = {enable = true},
                callable = {snippets = "fill_arguments"},
                excludeTraits = {},
                fullFunctionSignatures = {enable = true},
                hideDeprecated = false,
                limit = nil,
                postfix = {enable = true},
                privateEditable = {enable = true},
                snippets = default_snippets,
                termSearch = {enable = false, fuel = 1000}
            },
            diagnostics = {
                disabled = {},
                enable = true,
                experimental = {enable = true},
                remapprefix = {},
                styleLints = {enable = true},
                warningsAsHint = {},
                warningsAsInfo = {"unused_variables"}
            },
            files = {exclude = {}, watcher = "client"},
            highlightRelated = {
                breakPoints = {enable = true},
                closureCaptures = {enable = true},
                exitPoints = {enable = true},
                references = {enable = true},
                yieldPoints = {enable = true}
            },
            hover = {
                actions = {
                    enable = true,
                    gotoTypeDef = {enable = true},
                    implementations = {enable = false},
                    references = {enable = false},
                    run = {enable = true},
                    updateTest = {enable = true}
                },
                documentation = {enable = true, keywords = {enable = true}},
                dropGlue = {enable = true},
                links = {enable = true},
                maxSubstitutionLength = 100,
                memoryLayout = {
                    alignment = "hexadecimal",
                    enable = true,
                    niches = true,
                    offset = "hexadecimal",
                    padding = nil,
                    size = "both"
                },
                show = {enumVariants = 5, fields = 5, traitAssocItems = nil}
            },
            imports = {
                granularity = {enforce = false, enable = true, group = "crate"},
                group = {enable = true},
                merge = {glob = true},
                preferNoStd = false,
                preferPrelude = false,
                prefix = "crate",
                prefixExternPrelude = false
            },
            inlayHints = {
                bindingModeHints = {enable = true},
                chainingHints = {enable = true},
                closingBraceHints = {enable = true, minLines = 0},
                closureCaptureHints = {enable = true},
                closureReturnTypeHints = {enable = "always"},
                closureStyle = "impl_fn",
                discriminantHints = {enable = "always"},
                expressionAdjustmentHints = {
                    enable = "always",
                    hideOutsideUnsafe = false,
                    mode = "prefix"
                },
                genericParameterHints = {
                    const = {enable = true},
                    lifetyime = {enable = true},
                    type = {enable = true}
                },
                implicitDrops = {enable = true},
                implicitSizedBoundHints = {enable = true},
                lifetimeElisionHints = {
                    enable = "always",
                    useParameterNames = true
                },
                maxLength = nil,
                parameterHints = {enable = true},
                rangeExclusiveHints = {enable = true},
                reborrowHints = {enable = "always"},
                renderColons = true,
                typeHints = {
                    enable = true,
                    hideClosureInitialization = false,
                    hideClosureParameter = false,
                    hideNamedConstructor = false
                }
            },
            interpret = {tests = false},
            joinLines = {
                joinAssignments = true,
                joinElseIf = true,
                removeTrailingComma = true,
                unwrapTrivialBlock = true
            },
            lens = {
                debug = {enable = true},
                enable = true,
                implementations = {enable = true},
                location = "above_name",
                references = {
                    adt = {enable = true},
                    enumVariant = {enable = true},
                    method = {enable = true},
                    trait = {enable = true}
                },
                run = true,
                updateTest = {enable = true}
            },
            linkedProjects = {},
            lru = {capacity = 512, query = {capacities = nil}},
            notifications = {cargoTomlNotFound = true, unindexedProject = true},
            numThreads = nil,
            procMacro = {
                attributes = {enable = true},
                enable = true,
                ignored = nil,
                server = nil
            },
            references = {excludeImports = false, excludeTests = false},
            runnables = {
                command = nil,
                extraArgs = {},
                extraTestBinaryArgs = {"--show-output"}
            },
            rustc = {source = nil},
            rustfmt = {
                extraArgs = nil,
                overrideCommand = nil,
                rangeFormatting = {enable = true}
            },
            semanticHighlighting = {
                doc = {comment = {inject = {enable = true}}},
                nonStandardTokens = true,
                operator = {enable = true, specialization = {enable = true}},
                punctation = {
                    enable = true,
                    specialization = {enable = true},
                    separate = {macro = {bang = true}}
                },
                strings = {enable = true}
            },
            signatureInfo = {detail = "full", documentation = {enable = false}},
            typing = {
                triggerChars = "=.",
                autoClosingAngleBrackets = {enable = true}
            },
            vfs = {extraIncludes = {}},
            workspace = {discoverConfig = nil}
        }
    },
    single_file_support = true,
    capabilities = get_complete_capabilities(),
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
        inline_float_diagnostics(client, bufnr)
    end
}
