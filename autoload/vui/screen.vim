function! vui#screen#new()
    " extends node
    let obj                 = vui#node#new()
    let obj._buffer         = -1
    let obj._lines          = []
    let obj._modified_lines = []
    let obj._root_component      = {}
    let obj._type           = "screen"

    "disable manual sizing of screen (using window size)
    call remove(obj, 'set_width')
    call remove(obj, 'set_height')

    function! obj.set_root_component(component)
        let self._root_component = a:component
    endfunction

    function! obj.get_root_component()
        return self._root_component
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
        let l:line = a:y
        let l:col  = a:x

        call self.ensure_col_exists(l:line, l:col)
        let self._lines[l:line] = vui#util#replace_string(self._lines[l:line], a:string, l:col)
        call self.mark_line_as_modified(l:line)
    endfunction

    function! obj.render()
        if !has_key(self._root_component, '_is_component') || !self._root_component._is_component || !self.is_focused()
            return
        endif

        let l:current_cursor_pos = getcurpos()
        call self.clear()

        call self._root_component.render(self)

        let l:size  = len(self._modified_lines)
        if l:size == 0
            return
        endif
        let l:index = 0

        setlocal modifiable

        while l:index < l:size
            let l:line_number = self._modified_lines[l:index]
            call setline(l:line_number + 1, self._lines[l:index])
            let l:index += 1
        endwhile
        setlocal nomodifiable
        call setpos('.', l:current_cursor_pos)
    endfunction

    function! obj.mark_line_as_modified(line)
        if index(self._modified_lines, a:line) >= 0
            return
        endif

        call add(self._modified_lines, a:line)
    endfunction

    function! obj.ensure_line_exists(line)
        if a:line < 0
            return
        endif

        let l:lines_qtty = len(self._lines)
        if l:lines_qtty > a:line
            return
        endif

        while l:lines_qtty <= a:line
            call add(self._lines,  "")
            call self.mark_line_as_modified(l:lines_qtty)
            let l:lines_qtty += 1
        endwhile
    endfunction

    function! obj.ensure_col_exists(line, col)
        call self.ensure_line_exists(a:line)
        let l:line_size    = len(self._lines[a:line])
        if l:line_size >= a:col
            return
        endif
        let self._lines[a:line] .= repeat(' ', a:col - l:line_size)
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

        let self._lines          = []
        let self._modified_lines = []
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
