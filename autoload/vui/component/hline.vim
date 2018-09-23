function! vui#component#hline#new(x, y, size)
    let obj       = vui#component#line#new('h', a:x, a:y, a:size)
    let obj._type = "hline"

    return obj
endfunction
