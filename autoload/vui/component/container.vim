function! vui#component#container#new()
    let obj       = vui#component#base#new()
    let obj._type = "container"

    function! obj.render(render_buffer)
        call self.render_children(a:render_buffer)
    endfunction

    return obj
endfunction
