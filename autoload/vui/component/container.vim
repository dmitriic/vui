function! vui#component#container#new()
    let obj       = vui#component#base#new()
    let obj._type = "container"

    function! obj.render(screen)
        call self.render_children(a:screen)
    endfunction

    return obj
endfunction
