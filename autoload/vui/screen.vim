function! vui#screen#new()
    " extends node
    let obj                 = vui#node#new()
    let obj._buffer         = -1
    let obj._render_buffer  = vui#render_buffer#new(obj)
    let obj._root_component = {}
    let obj._type           = "screen"
    let obj._width          = 0
    let obj._height         = 0

    function! obj.set_root_component(component)
        let self._root_component = a:component
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

        let l:cursor_position.x = l:cursor_pos[1] - 1
        let l:cursor_position.y = l:cursor_pos[4] - 1

        return l:cursor_position
    endfunction

    function! obj.set_cursor_position(x, y)
        if !self.is_focused()
            return
        endif

        call cursor(a:x + 1, 0)
        execute "silent normal! " . (a:y + 1) . '|'
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
        if !self.has_root_component()
            call self.clear()
            return
        endif

        if !self.is_focused()
            call self.focus()
        endif

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
    endfunction

    function! obj.show()
        call self.focus()
        call self.update_size()
        call self.render()
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

    function! obj.focus()
        if self.is_focused()
            return
        endif

        if self._buffer < 0 || !bufexists(self._buffer)
            enew
            let self._buffer = bufnr('%')
            setlocal buftype=nofile
            setlocal bufhidden=hide
            setlocal noswapfile
            setlocal nomodifiable
            setlocal nonumber
            setlocal norelativenumber
            setlocal signcolumn=no
            setlocal cc=0
            setlocal filetype=vui
            setlocal listchars=

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

    function! obj.get_width()
        return self._width
    endfunction

    function! obj.get_height()
        return self._height
    endfunction

    return obj
endfunction
