function! vui#component#base#new()
    let obj = vui#node#new()

    let obj._x            = 0
    let obj._y            = 0
    let obj._z            = 0
    let obj._width        = 0
    let obj._height       = 0
    let obj._visible      = 1
    let obj._focusable    = 0
    let obj._is_component = 1
    let obj._type         = "base_component"

    function! obj.render(render_buffer)
        call self.render_children(a:render_buffer)
    endfunction

    function! obj.update(screen)
        call self.update_children(a:screen)
    endfunction

    function! obj.render_children(render_buffer)
        if !self.has_children()
            return
        endif

        for l:i in range(0, self._num_children - 1)
            if self._children[l:i].should_render() == 1
                call self._children[l:i].render(a:render_buffer)
            endif
        endfor
    endfunction

    function! obj.update_children(screen)
        if !self.has_children()
            return
        endif

        for l:i in range(0, self._num_children - 1)
            call self._children[l:i].update(a:screen)
        endfor
    endfunction

    function! obj.get_x()
        return self._x
    endfunction

    function! obj.set_x(x)
        let l:changed = !vui#util#is_equal(a:x, self._x)
        let self._x = a:x
        call self.emit_if(l:changed, 'changed', self)
    endfunction

    function! obj.get_global_x()
        if (!self.has_parent())
            return self.get_x()
        endif

        return self.get_x() + self.get_parent().get_global_x()
    endfunction

    function! obj.get_global_y()
        if (!self.has_parent())
            return self.get_y()
        endif

        return self.get_y() + self.get_parent().get_global_y()
    endfunction

    function! obj.get_y()
        return self._y
    endfunction

    function! obj.set_y(y)
        let l:changed = !vui#util#is_equal(a:y, self._y)
        let self._y = a:y
        call self.emit_if(l:changed, 'changed', self)
    endfunction

    function! obj.get_bounding_box()
        let l:bbox = vui#bounding_box#new(self.get_x(), self.get_y(), self.get_width(), self.get_height())
        return l:bbox
    endfunction

    function! obj.get_z()
        return self._z
    endfunction

    function! obj.set_z(z)
        let l:changed = !vui#util#is_equal(a:z, self._z)
        let self._z = a:z
        call self.emit_if(l:changed, 'changed', self)
    endfunction

    function! obj.get_visible()
        return self._visible
    endfunction

    function! obj.set_visible(visible)
        let l:changed = !vui#util#is_equal(a:visible, self._visible)
        let self._visible = a:visible
        call self.emit_if(l:changed, 'changed', self)
    endfunction

    function! obj.is_visible()
        return self._visible
    endfunction

    function! obj.get_focusable()
        return self._focusable
    endfunction

    function! obj.set_focusable(focusable)
        let l:changed = !vui#util#is_equal(a:focusable, self._focusable)
        let self._focusable = a:focusable
        call self.emit_if(l:changed, 'changed', self)
    endfunction

    function! obj.should_render()
        if self.get_width() == 0 || self.get_height() == 0 || !self.is_visible()
            return 0
        endif

        return 1
    endfunction

    function! obj.get_width()
        return self._width
    endfunction

    function! obj.set_width(width)
        let l:changed = !vui#util#is_equal(a:width, self._width)
        let self._width = a:width
        call self.emit_if(l:changed, 'changed', self)
    endfunction

    function! obj.get_height()
        return self._height
    endfunction

    function! obj.set_height(height)
        let l:changed = !vui#util#is_equal(a:height, self._height)
        let self._height = a:height
        call self.emit_if(l:changed, 'changed', self)
    endfunction

    function! obj.get_size()
        let l:size = { 'width': self._width, 'height': self._height }
        return l:size
    endfunction

    return obj
endfunction
