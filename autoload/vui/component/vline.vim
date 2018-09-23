function! vui#component#vline#new(x, y, size)
    let obj       = vui#component#line#new('v', a:x, a:y, a:size)
    let obj._type = "vline"

    return obj
endfunction
