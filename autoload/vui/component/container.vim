function! vui#component#container#new(width, height)
    let obj       = vui#component#base#new()
    let obj._type = "container"

    call obj.set_width(a:width)
    call obj.set_height(a:height)

    return obj
endfunction


