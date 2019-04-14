" function! s:rerender(screen, component)
"     if a:screen._is_rendering
"         return
"     endif
"     call a:screen.render()
" endfunction


function! vui#screen#new()
    " extends node
    let obj                 = vui#node#new()
    let obj._buffer         = -1
    let obj._render_buffer  = vui#render_buffer#new(obj)
    let obj._root_component = {}
    let obj._type           = "screen"
    let obj._width          = 0
    let obj._height         = 0
    let obj._is_rendering   = 0
    let obj._focusables     = []
    let obj._focus_index    = -1

    function! obj.set_root_component(component)
        let self._root_component = a:component
        " call a:component.on('changed', function('s:rerender', [self]))
    endfunction

    function! obj.get_root_component()
        return self._root_component
    endfunction

    function! obj.has_root_component()
        return has_key(self._root_component, '_is_component') && self._root_component._is_component == 1
    endfunction

    function! obj.get_render_buffer()
        return self._render_buffer
    endfunction

    function! obj.get_cursor_position()
        let l:cursor_position = {"x": -1, "y": -1}

        if !self.is_focused()
            return l:cursor_position
        endif

        let l:cursor_pos = getcurpos()

        let l:cursor_position.x = l:cursor_pos[4] - 1
        let l:cursor_position.y = l:cursor_pos[1] - 1

        return l:cursor_position
    endfunction

    function! obj.set_cursor_position(x, y)
        if !self.is_focused()
            return
        endif

        call cursor(a:y + 1, 0)
        execute "silent normal! " . (a:x + 1) . '|'
    endfunction

    function! obj.update_size()
        if !self.is_focused()
            return
        endif
        let l:new_width  = winwidth(0)
        let l:new_height = winheight(0)

        let l:emit = 0
        if l:new_width != self._width || l:new_height != self._height
            let l:emit = 1
        endif

        let self._width  = l:new_width
        let self._height = l:new_height

        if l:emit
            call self.emit('size_changed', self)
        endif
    endfunction

    function! obj.is_focused()
        let l:current_buffer = bufnr('%')
        if l:current_buffer == self._buffer
            return 1
        else
            return 0
        endif
    endfunction

    function! obj.put(x, y, string)
        self._render_buffer.put(a:x, a:y, a:string)
    endfunction

    function! obj.render()
        if self._is_rendering
            return
        endif

        if !self.has_root_component() || !self.get_root_component().is_visible()
            call self.clear()
            let self._is_rendering = 0
            return
        endif

        if !self.is_focused()
            call self.focus()
        endif

        let self._is_rendering = 1

        let l:current_cursor_pos = getcurpos()

        call self._render_buffer.set_root_component(self._root_component)
        call self._root_component.update(self)
        call self._render_buffer.render()

        setlocal modifiable

        let l:lines_size     = line('$')
        let l:new_lines      = self._render_buffer.get_lines()
        let l:new_lines_size = len(l:new_lines)

        for l:index in range(0, l:new_lines_size - 1)
            let l:current_line = l:index >= l:lines_size ? "" : getline(l:index + 1)
            let l:new_line     = l:new_lines[l:index]
            if l:new_line == ""
                call append(l:index, '')
            elseif l:new_line !=# l:current_line
                call setline(l:index + 1, l:new_line)
            endif
        endfor

        if (l:new_lines_size < l:lines_size)
            execute (l:new_lines_size + 1) . ',$d'
        endif

        setlocal nomodifiable

        call setpos('.', l:current_cursor_pos)
        let self._is_rendering = 0

        call self.update_focusables()
        call self._apply_buffer_options()
    endfunction

    function! obj.show()
        call self.focus()
        call self.update_size()
        call self.render()
        call self.focus_next_element()
    endfunction

    function! obj.clear()
        if !self.is_focused()
            return
        endif

        setlocal modifiable
        execute "silent normal! ggdG"
        call self._render_buffer.clear()
        setlocal nomodifiable
    endfunction

    function! obj._apply_buffer_options()
        setlocal buftype=nofile
        setlocal bufhidden=hide
        setlocal noswapfile
        setlocal nomodifiable
        setlocal nonumber
        setlocal norelativenumber
        setlocal nocursorline
        setlocal signcolumn=no
        setlocal cc=0
        setlocal listchars=
        setlocal nowrap

        if &filetype != 'vui'
            "only trigger ftplugins once
            setlocal filetype=vui
        endif
    endfunction



    function! obj.focus()
        if self.is_focused()
            return
        endif

        if self._buffer < 0 || !bufexists(self._buffer)
            enew
            let self._buffer = bufnr('%')
            call self._apply_buffer_options()

            let b:screen = self
            "temporary
            "execute "silent IndentLinesDisable"
            "autocmd  TO-DO listen for resize of window
            "augroup vui_external_events
            "    autocmd! * <buffer>
            "    autocmd Name <bufffer> command
            "augroup END
        else
            execute "silent buffer " . self._buffer
        endif
    endfunction

    function! obj.focus_first_element()
        let l:size = len(self._focusables)

        if l:size == 0
            let self._focus_index = -1
            return
        endif

        let self._focus_index = 0

        let l:x = self._focusables[0].get_global_x()
        let l:y = self._focusables[0].get_global_y()

        call self.set_cursor_position(l:x, l:y)
    endfunction

    function! obj.focus_last_element()
        let l:size = len(self._focusables)

        if l:size == 0
            let self._focus_index = -1
            return
        endif

        let l:new_index = l:size - 1
        let self._focus_index = l:new_index

        let l:x = self._focusables[l:new_index].get_global_x()
        let l:y = self._focusables[l:new_index].get_global_y()

        call self.set_cursor_position(l:x, l:y)
    endfunction

    function! obj.focus_next_element()
        let l:size = len(self._focusables)

        if l:size == 0
            let self._focus_index = -1
            return
        endif

        let l:new_index = self._focus_index + 1

        if l:new_index == l:size
            let l:new_index = 0
        endif
        let self._focus_index = l:new_index

        let l:x = self._focusables[self._focus_index].get_global_x()
        let l:y = self._focusables[self._focus_index].get_global_y()

        call self.set_cursor_position(l:x, l:y)
    endfunction

    function! obj.focus_previous_element()
        let l:size = len(self._focusables)

        if l:size == 0
            let self._focus_index = -1
            return
        endif

        let l:new_index = self._focus_index - 1

        if l:new_index < 0
            let l:new_index = len(self._focusables) - 1
        endif

        let self._focus_index = l:new_index

        let l:x = self._focusables[self._focus_index].get_global_x()
        let l:y = self._focusables[self._focus_index].get_global_y()

        call self.set_cursor_position(l:x, l:y)
    endfunction

    function! obj.update_focusables()
        let self._focusables = []
        if !self.has_root_component()
            return
        endif
        call self._do_update_focusables(self._focusables, [self._root_component])
        "TODO sort by focus_index (not existent yet)
    endfunction


    function! obj._do_update_focusables(list, children)
        let l:num_children = len(a:children)
        for l:i in range(0, l:num_children - 1)
            if a:children[l:i].is_focusable() && a:children[l:i].is_visible()
                call add(a:list, a:children[l:i])
            endif
            if a:children[l:i].has_children()
                call self._do_update_focusables(a:list, a:children[l:i]._children)
            endif
        endfor
    endfunction

    function! obj.get_width()
        return self._width
    endfunction

    function! obj.get_height()
        return self._height
    endfunction

    function! obj.perform_action()
        let l:count = len(self._focusables)

        if l:count == 0
            return
        endif

        let l:position = self.get_cursor_position()
        if l:position.x < 0 || l:position.y < 0
            return
        endif

        let l:targets = []
        let l:bounding_box = vui#bounding_box#new(l:position.x, l:position.y, 1, 1)

        for l:i in range(0, l:count - 1)
            if l:bounding_box.intersects(self._focusables[l:i].get_bounding_box())
                call add(l:targets, self._focusables[l:i])
            endif
        endfor

        let l:targets_count = len(l:targets)

        if l:targets_count == 0
            return
        endif


        "childs first
        call reverse(l:targets)

        for l:i in range(0, l:targets_count - 1)
            call l:targets[l:i].emit('action', l:targets[l:i])
        endfor
        call self.render()
    endfunction

    return obj
endfunction
