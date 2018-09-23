function! vui#screen#new()
    " extends node
    let obj                 = vui#node#new()
    let obj._buffer         = -1
    let obj._render_buffer  = vui#render_buffer#new(obj)
    let obj._root_component = {}
    let obj._type           = "screen"

    "disable manual sizing of screen (using window size)
    unlet obj.set_width
    unlet obj.set_height

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
        let self._width  = winwidth(0)
        let self._height = winheight(0)
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

        let l:current_cursor_pos = getcurpos()

        call self._render_buffer.set_root_component(self._root_component)
        call self._render_buffer.render()

        setlocal modifiable

        let l:lines_size     = line('$')
        let l:new_lines      = self._render_buffer.get_lines()
        let l:new_lines_size = len(l:new_lines)

        for l:index in range(0, l:new_lines_size - 1)
            let l:current_line = l:index >= l:lines_size ? "" : getline(l:index + 1)
            let l:new_line     = l:new_lines[l:index]
            if l:new_line !=# l:current_line
                call setline(l:index + 1, l:new_line)
            endif
        endfor

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

        execute "silent normal! ggdG"
        self._render_buffer.clear()
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
            "temporary
            execute "silent IndentLinesDisable"
            "autocmd  TO-DO listen for resize of window
        else
            execute "silent buffer " . self._buffer
        endif
    endfunction

    return obj
endfunction
