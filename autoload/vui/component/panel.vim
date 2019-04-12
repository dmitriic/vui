function! vui#component#panel#new(title, width, height)
    let obj        = vui#component#base#new()
    let obj._type  = "panel"
    let obj._title = a:title

    call obj.set_width(a:width)
    call obj.set_height(a:height)

    let obj._box               = vui#component#box#new(0, 0, a:width, a:height)
    let obj._divider           = vui#component#hline#new(1, 2, a:width - 2)
    let obj._title_component   = vui#component#text#new(a:title)
    let obj._content_component = vui#component#base#new()

    call obj.add_child(obj._box)
    call obj.add_child(obj._divider)
    call obj.add_child(obj._title_component)
    call obj.add_child(obj._content_component)

    call vui#util#set_default_value('g:vui_box_t_right', '┤')
    call vui#util#set_default_value('g:vui_box_t_left', '├')

    " if !exists('g:vui_box_t_top')
    "     let g:vui_box_t_top = '┬'
    " endif

    " if !exists('g:vui_box_t_bottom')
    "     let g:vui_box_t_bottom = '┴'
    " endif

    function! obj.get_title()
        return self._title
    endfunction

    function! obj.set_title(title)
        let self._title = a:title
        self._title_component.clear()
        self._title_component.add_line(a:title)
    endfunction

    function! obj.get_content_component()
        return self._content_component
    endfunction

    function! obj.get_title_component()
        return self._title_component
    endfunction

    function! obj.render(render_buffer)
        let l:text_pos = 1 + (self.get_width() - self._title_component.get_width()) / 2

        if l:text_pos <= 0
            let l:text_pos = 1
        endif

        call self._title_component.set_x(l:text_pos)
        call self._title_component.set_y(1)
        call self._divider.set_y(2)


        call self._content_component.set_y(3)
        call self._content_component.set_x(1)

        call self._box.set_width(self.get_width())
        call self._box.set_height(self.get_height())
        call self._box.render(a:render_buffer)

        call self._divider.set_size(self.get_width() - 2)

        " call self._divider._width  = self.get_width() - 2
        " call self._divider._height = self.get_height() - 2

        call self._divider.render(a:render_buffer)

        call self._title_component.render(a:render_buffer)
        call self._content_component.render(a:render_buffer)

        call a:render_buffer.put(self.get_global_x(), self.get_global_y() + 2, g:vui_box_t_left)
        call a:render_buffer.put(self.get_global_x() + self.get_width(), self.get_global_y() + 2, g:vui_box_t_right)

    endfunction

    return obj
endfunction
