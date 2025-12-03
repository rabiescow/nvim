function nvim-depends --description "install all the neovim programming dependencies"
    if not command -v npm &>/dev/null
        sudo pacman -S --needed --noconfirm npm nodejs
    end

    set -l ocaml_first_install false
    if not command -v ocaml &>/dev/null
        set ocaml_first_install true
    end

    echo "download tree-sitter dependencies"
    sudo pacman -S --needed --noconfirm tree-sitter tree-sitter-{bash,c,cli,\
        javascript,lua,markdown,python,query,rust,vim,vimdoc}
    # yay -S --needed --noconfirm tree-sitter-{zig,yaml,xml,toml,sql,scala,regex,\
    yay -S --needed --noconfirm tree-sitter-{zig,yaml,toml,sql,scala,regex,\
        r,go,typescript,json,css,ruby,cpp,php,ocaml,meson,make,latex,kotlin,\
        julia,jsonc,jsdoc,java,html,haskell,gomod,fish,erlang-git,elixir,\
        commonlisp,clojure-git,c-sharp}

    echo "download programming langages"
    sudo pacman -S --needed --noconfirm base-devel gcc bash glibc lib32-glibc clang bear \
        clang18 clang19 dart elixir erlang erlang-{asni,cl,common_test,core,\
        debugger,dialyzer,diameter,docs,edoc,eldap,erl_interface,et,eunit,ftp,\
        headless,inets,jinterface,megaco,mnesia,observer,odbc,os_mon,parsetools,\
        public_key,reltool,sasl,snmp,ssh,ssl,syntax_tools,tftp,tools,wx,xmerl} \
        rebar3 fish gcc-fortran gcc-libs lib32-gcc-libs gcc14-fortran go ghc \
        ghc-libs haskell-ghc-paths lua libluv lua51 lua52 lua53 luarocks \
        luajit lua-{argparse,basexx,binaryheap,bit32,busted,cassowary,cliargs,\
        dkjson,expat,filesystem,http,inifile,jsregexp,lanes,loadkit,lpeg,\
        luarepl,location,luassert,luautf8,luv,posix,say,sec,socket,stdlib, \
        system,term,vstruct,yaml,zlib} odin ocaml opam dune perl pcre pcre2 cl-ppcre \
        python qt5-{3d,base,charts,connectivity,declarative,doc,examples,\
        feedback,graphicaleffects,imageformats,location,multimedia,networkauth,\
        quick3d,quickcontrols,quickcontrols-nemo,quickcontrols2,remoteobjects,\
        script,scxml,sensors,serialport,speech,svg,systems,tools,translations,\
        ukui-platformtheme,virtualkeyboard,wayland,webengine,websockets,\
        webchannel,x11extras,xcb-private-headers,xmlpatterns} \
        qt6-{3d,5compat,base,charts,connectivity,datavis3d,declarative,doc,\
        examples,graphs,grpc,httpserver,imageformats,location,lottie,mqtt,\
        multimedia,multimedia-ffmpeg,multimedia-gstreamer,networkauth,\
        positioning,quick3d,quick3dphysics,quickeffectmaker,quicktimeline,\
        remoteobjects,scxml,sensors,serialbus,serialport,shadertools,speech,\
        svg,tools,translations,virtualkeyboard,wayland,webchannel,webengine,\
        websockets,webview,xcb-private-headers} \
        r ruby rbenv rubygems rustup biome typescript zig
    if not command -v elm &>/dev/null
        sudo npm install -g elm
    end

    # set up ocaml environment default
    if $ocaml_first_install
        eval (opam init)
    end

    echo "download language servers"
    sudo pacman -S --needed --noconfirm pyright bash-language-server gopls \
        haskell-language-server lua-language-server vscode-html-languageserver \
        vscode-json-languageserver vscode-css-languageserver qt6-languageserver \
        ruby-lsp rust-analyzer typescript-language-server yaml-language-server \
        zls markdown-oxide
    yay -S --needed --noconfirm basedpyright elixir-ls erlang_ls fish-lsp \
        fortls hyprls-git odinls qml-lsp-git r-languageserver eslint-language-server \
        ts_query_ls-bin
    opam install --yes ocaml-lsp-server
    if not command -v elm-language-server &>/dev/null
        sudo npm install -g elm-language-server
    end

    echo "downloading formatters"
    sudo pacman -S --needed --noconfirm shfmt hindent odinfmt stylua markdownlint
    yay -S --needed --noconfirm clang-format dart_format format-dune-file \
        elm_format fish_indent fprettify findent google-java-format jq \
        fixjson lua-format rubyfmt isort qmlformat rustfmt \
        xmlformatter xmllint yamlfix yamlfmt zigfmt
    if not command -v elm-format &>/dev/null
        sudo npm install -g elm-format
    end
    opam install --yes ocamlformat ocamlformat-lib ocamlformat-rpc-lib ocpindent
    if not command -v goimports &>/dev/null
        go install golang.org/x/tools/cmd/goimports@latest
    end
    if not command -v golines &>/dev/null
        go install github.com/segmentio/golines@latest
    end

    return 0
end
