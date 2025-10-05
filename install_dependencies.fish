function dependencies --description "install all the neovim dependencies"
    echo "download tree-sitter dependencies"
    sudo pacman -S --needed --noconfirm tree-sitter tree-sitter-bash tree-sitter-c \
        tree-sitter-cli tree-sitter-javascript tree-sitter-lua tree-sitter-markdown \
        tree-sitter-python tree-sitter-query tree-sitter-rust tree-sitter-vim \
        tree-sitter-vimdoc

    echo "download programming lanugages"

    sudo pacman -S --needed --noconfirm base-devel gcc bash glibc lib32-glibc clang bear \
        clang18 clang19 dart elixir erlang erlang-{asni,cl,common_test,core,debugger,dialyzer,diameter,docs,edoc,eldap,erl_interface,et,eunit,ftp,headless,inets,jinterface,megaco,mnesia,observer,odbc,os_mon,parsetools,public_key,reltool,sasl,snmp,ssh,ssl,syntax_tools,tftp,tools,wx,xmerl} \
        rebar3 fish gcc-fortran gcc-libs lib32-gcc-libs gcc14-fortran go ghc \
        ghc-libs haskell-ghc-paths lua libluv lua51 lua52 lua53 luarocks \
        luajit lua-{argparse,basexx,binaryheap,bit32,busted,cassowary,cliargs,dkjson,expat,filesystem,http,inifile,jsregexp,lanes,loadkit,lpeg,luarepl,location,luassert,luautf8,luv,posix,say,sec,socket,stdlib,system,term,vstruct,yaml,zlib} \
        ocaml opam dune perl pcre pcre2 cl-ppcre python \
        qt5-{3d,base,charts,connectivity,declarative,doc,examples,feedback,graphicaleffects,imageformats,location,multimedia,networkauth,quick3d,quickcontrols,quickcontrols-nemo,quickcontrols2,remoteobjects,script,scxml,sensors,serialport,speech,svg,systems,tools,translations,ukui-platformtheme,virtualkeyboard,wayland,webengine,websockets,webchannel,x11extras,xcb-private-headers,xmlpatterns} \
        qt6-{3d,5compat,base,charts,connectivity,datavis3d,declarative,doc,examples,graphs,grpc,httpserver,imageformats,location,lottie,mqtt,multimedia,multimedia-ffmpeg,multimedia-gstreamer,networkauth,positioning,quick3d,quick3dphysics,quickeffectmaker,quicktimeline,remoteobjects,scxml,sensors,serialbus,serialport,shadertools,speech,svg,tools,translations,virtualkeyboard,wayland,webchannel,webengine,websockets,webview,xcb-private-headers} \
        r ruby rbenv rubygems rustup biome typescript zig

    echo "download language servers"
    sudo pacman -S --needed --noconfirm pyright bash-language-server gopls \
        haskell-language-server lua-language-server vscode-html-languageserver \
        vscode-json-languageserver vscode-css-languageserver qt6-languageserver \
        ruby-lsp rust-analyzer typescript-language-server yaml-language-server \
        zls

    yay -S --needed --noconfirm basedpyright elixir-ls erlang_ls fish-lsp \
        fortls hyprls-git qml-lsp-git r-languageserver eslint-language-server

    return 0
end
