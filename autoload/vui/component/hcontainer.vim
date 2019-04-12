function! vui#component#hcontainer#new()
    let obj       = vui#component#base#new()
    let obj._type = "hcontainer"

    function!obj.update(screen)
        if !self.has_children()
            return
        endif

        call self.update_children(a:screen)

        let l:x      = 0
        let l:height = 0

        for l:i in range(0, self._num_children - 1)
            if self._children[l:i].should_render() == 1
                call self._children[l:i].set_x(l:x)
                let l:x      = l:x + self._children[l:i].get_width() + 1
                let l:height = max([l:height, self._children[l:i].get_height()])
            endif
        endfor
        call self.set_width(l:x - 1)
        call self.set_height(l:height)
    endfunction

    function! obj.should_render()
        if !self.has_children() || !self.is_visible()
            return 0
        endif

        return 1
    endfunction

    return obj
endfunction

