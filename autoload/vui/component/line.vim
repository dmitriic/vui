function! vui#component#line#new(direction, x, y, size)
    let obj            = vui#component#base#new()
    let obj._type      = "line"
    let obj._direction = a:direction == 'v' ? 'v' : 'h'

    call obj.set_width(a:size)
    call obj.set_height(a:size)
    call obj.set_x(a:x)
    call obj.set_y(a:y)

    let obj._parent_get_height = obj.get_height
    let obj._parent_get_width  = obj.get_width

    call vui#util#set_default_value('g:vui_horizontal_line_char', '─')
    call vui#util#set_default_value('g:vui_vertical_line_char', '│')

    function! obj.render(render_buffer)
        let l:start  = self.is_horizontal() ? self.get_global_x() : self.get_global_y()
        let l:end    = l:start + (self.is_horizontal() ? self.get_width() : self.get_height())

        if (self.is_horizontal())
            for l:x in range(l:start, l:end)
                call a:render_buffer.put(l:x, self.get_global_y(), g:vui_box_horizontal_line_char)
            endfor
        else
            if (self.is_vertical())
                for l:y in range(l:start, l:end)
                    call a:render_buffer.put(self.get_global_x(), l:y, g:vui_box_vertical_line_char)
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
            return self._parent_get_height()
        endif

        return 1
    endfunction

    function! obj.get_width()
        if self.is_horizontal()
            return self._parent_get_width()
        endif

        return 1
    endfunction

    return obj
endfunction
