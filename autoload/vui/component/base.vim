function! vui#component#base#new()
    let obj = vui#node#new()

    let obj._x            = 0
    let obj._y            = 0
    let obj._z            = 0
    let obj._children     = []
    let obj._visible      = 1
    let obj._focusable    = 0
    let obj._parent       = {}
    let obj._is_component = 1
    let obj._type         = "base_component"

    function! obj.render(render_buffer)
        echoerr "Render not implemented for this component"
    endfunction

    function! obj.render_children(render_buffer)
        let l:children_count = len(self._children)

        if l:children_count == 0
            return
        endif

        for l:i in range(0, l:children_count - 1)
            if self._children[l:i].should_render() == 1
                call self._children[l:i].render(a:render_buffer)
            endif
        endfor
    endfunction

    function! obj.get_x()
        return self._x
    endfunction

    function! obj.set_x(x)
        let self._x = a:x
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
        let self._y = a:y
    endfunction

    function! obj.get_bounding_box()
        let l:bbox = vui#bounding_box#new(self.get_x(), self.get_y(), self.get_width(), self.get_height())
        return l:bbox
    endfunction

    function! obj.get_z()
        return self._z
    endfunction

    function! obj.set_z(z)
        let self._z = a:z
    endfunction

    function! obj.get_visible()
        return self._visible
    endfunction

    function! obj.set_visible(visible)
        let self._visible = a:visible
    endfunction

    function! obj.is_visible()
        return self._visible
    endfunction

    function! obj.get_focusable()
        return self._focusable
    endfunction

    function! obj.set_focusable(focusable)
        let self._focusable = a:focusable
    endfunction

    function! obj.should_render()
        if self.get_width() == 0 || self.get_height() == 0 || !self.is_visible()
            return 0
        endif

        return 1
    endfunction

    function! obj.add_child(node)
        if !has_key(a:node, "_is_component") || !a:node._is_component
            return
        endif
        call a:node.set_parent(self)
        call add(self._children, a:node)
    endfunction

    function! obj.has_parent()
        if !has_key(self._parent, "_is_component") || !self._parent._is_component
            return 0
        endif
        return 1
    endfunction

    function! obj.get_parent()
        return self._parent
    endfunction

    function! obj.set_parent(parent)
        let self._parent = a:parent
    endfunction

    function! obj.remove_child(node)
        if !has_key(a:node, "_is_component") || !a:node._is_component
            return
        endif
        " call add(self._children, node)
    endfunction

    return obj
endfunction
