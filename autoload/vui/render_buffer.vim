function! vui#render_buffer#new(screen)
    " extends node
    let obj                 = vui#node#new()
    let obj._lines          = []
    let obj._modified_lines = []
    let obj._root_component = {}
    let obj._screen         = a:screen
    let obj._type           = "render_buffer"

    "disable manual sizing of screen (using window size)
    " unlet obj.set_width
    " unlet obj.set_height

    function! obj.set_root_component(component)
        let self._root_component = a:component
    endfunction

    function! obj.get_root_component()
        return self._root_component
    endfunction

    function! obj.get_screen()
        return self._screen
    endfunction

    function! obj.put(x, y, string)
        let l:line = a:y
        let l:col  = a:x

        call self.ensure_col_exists(l:line, l:col)
        let self._lines[l:line] = vui#util#replace_string(self._lines[l:line], a:string, l:col)
        call self.mark_line_as_modified(l:line)
    endfunction

    function! obj.get_lines()
        return self._lines
    endfunction

    function! obj.has_root_component()
        return has_key(self._root_component, '_is_component') && self._root_component._is_component == 1
    endfunction

    function! obj.render()
        call self.clear()
        if !self.has_root_component()
            return
        endif

        call self._root_component.render(self)

        if len(self._modified_lines) > 0
            call self.emit('changed', self)
        endif
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
        let l:line_size = len(self._lines[a:line])
        if l:line_size >= a:col
            return
        endif
        let self._lines[a:line] .= repeat(' ', a:col - l:line_size)
    endfunction

    function! obj.clear()
        let self._lines          = []
        let self._modified_lines = []
    endfunction

    return obj
endfunction
