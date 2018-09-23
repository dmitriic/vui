function! vui#component#line#new(direction, x, y, size)
    let obj            = vui#component#base#new()
    let obj._type      = "line"
    let obj._direction = a:direction == 'v' ? 'v' : 'h'

    call obj.set_width(a:size)
    call obj.set_height(a:size)
    call obj.set_x(a:x)
    call obj.set_y(a:y)

    let obj.Parent_get_width = obj.get_height
    let obj.Parent_get_width = obj.get_width

    if !exists('g:vui_horizontal_line_char')
        let g:vui_box_horizontal_line_char = '─'
    endif

    if !exists('g:vui_vertical_line_char')
        let g:vui_box_vertical_line_char = '│'
    endif

    function! obj.render(screen)
        let l:start  = self.is_horizontal() ? self.get_global_x() : self.get_global_y()
        let l:end    = l:start + (self.is_horizontal() ? self.get_width() : self.get_height())

        if (self.is_horizontal())
            for l:x in range(l:start, l:end)
                call a:screen.put(l:x, self.get_global_y(), g:vui_box_horizontal_line_char)
            endfor
        else
            if (self.is_vertical())
                for l:y in range(l:start, l:end)
                    call a:screen.put(self.get_global_x(), l:y, g:vui_box_vertical_line_char)
                endfor
            endif
        endif
    endfunction

    function! obj.is_horizontal()
        return self._direction == 'h'
    endfunction

    function! obj.set_size(size)
        let self._width  = a:size
        let self._height = a:size
    endfunction

    function! obj.is_vertical()
        return self._direction == 'v'
    endfunction

    function! obj.get_height()
        if self.is_vertical()
            return self.Parent_get_height()
        endif

        return 1
    endfunction

    function! obj.get_width()
        if self.is_horizontal()
            return self.Parent_get_width()
        endif

        return 1
    endfunction

    return obj
endfunction
