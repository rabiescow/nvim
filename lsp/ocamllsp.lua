return {
    cmd = {"ocamllsp"},
    filetypes = {
        "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "dune"
    },
    root_markers = {
        "*.opam", "esy.json", "package.json", ".git", "dune-project",
        "dune-workspace"
    },
    settings = {
        extendedHover = {enable = true},
        standardHover = {enable = true},
        codelens = {enable = true},
        duneDiagnostics = {enable = true},
        inlayHints = {
            hintPatternVariables = true,
            hintLetBindings = true,
            hintFunctionParams = true
        },
        syntaxDocumentation = {enable = true},
        merlinJumpCodeActions = {enable = true}
    },
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
    end,
    capabilities = get_complete_capabilities()
}
