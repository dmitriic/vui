function! vui#component#box#new(x, y, width, height)
    let obj       = vui#component#base#new()
    let obj._type = "box"

    call obj.set_x(a:x)
    call obj.set_y(a:y)
    call obj.set_width(a:width)
    call obj.set_height(a:height)

    call vui#util#set_default_value('g:vui_box_top_left_char', '┌')
    call vui#util#set_default_value('g:vui_box_top_right_char', '┐')
    call vui#util#set_default_value('g:vui_box_bottom_left_char', '└')
    call vui#util#set_default_value('g:vui_box_bottom_right_char', '┘')
    call vui#util#set_default_value('g:vui_box_horizontal_line_char', '─')
    call vui#util#set_default_value('g:vui_box_vertical_line_char', '│')

    " call vui#util#set_default_value('g:vui_box_top_left_char', '+')
    " call vui#util#set_default_value('g:vui_box_top_right_char', '+')
    " call vui#util#set_default_value('g:vui_box_bottom_left_char', '+')
    " call vui#util#set_default_value('g:vui_box_bottom_right_char', '+')
    " call vui#util#set_default_value('g:vui_box_horizontal_line_char', '-')
    " call vui#util#set_default_value('g:vui_box_vertical_line_char', '|')

    function! obj.render(render_buffer)
        let l:x_start = self.get_global_x()
        let l:x_end   = l:x_start + self.get_width() - 1
        let l:y_start = self.get_global_y()
        let l:y_end   = l:y_start + self.get_height() - 1

        ""corners
        let l:top    = g:vui_box_top_left_char
        let l:bottom = g:vui_box_bottom_left_char

         for l:x in range(l:x_start + 1, l:x_end - 1)
             let l:top    .= g:vui_box_horizontal_line_char
             let l:bottom .= g:vui_box_horizontal_line_char
        endfor
        let l:top    .= g:vui_box_top_right_char
        let l:bottom .= g:vui_box_bottom_right_char

        call a:render_buffer.put(l:x_start, l:y_start, l:top)
        call a:render_buffer.put(l:x_start, l:y_end, l:bottom)

        for l:y in range(l:y_start + 1, l:y_end - 1)
            call a:render_buffer.put(l:x_start, l:y, g:vui_box_vertical_line_char)
            call a:render_buffer.put(l:x_end, l:y, g:vui_box_vertical_line_char)
        endfor

        call self.render_children(a:render_buffer)
    endfunction

    return obj
endfunction
