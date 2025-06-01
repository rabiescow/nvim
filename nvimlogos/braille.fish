function brl
    rg ",$argv[1]" braille.txt \
        | head -n1 \
        | sed 's/^U+[A-F0-9]*,\(.*\),[0-9]*$/\1/' \
        | wl-copy -n
end
