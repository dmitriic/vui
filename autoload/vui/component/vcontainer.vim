function! vui#component#vcontainer#new()
    let obj       = vui#component#base#new()
    let obj._type = "vcontainer"

    function!obj.update(screen)
        if !self.has_children()
            return
        endif

        call self.update_children(a:screen)

        let l:y     = 0
        let l:width = 0
        for l:i in range(0, self._num_children - 1)
            if self._children[l:i].should_render() == 1
                call self._children[l:i].set_y(l:y)
                let l:y = l:y + self._children[l:i].get_height() + 1
                let l:width = max([l:width, self._children[l:i].get_width()])
            endif
        endfor

        call self.set_width(l:width)
        call self.set_height(l:y - 1)
    endfunction

    function! obj.should_render()
        if !self.has_children() || !self.is_visible()
            return 0
        endif

        return 1
    endfunction


    return obj
endfunction

