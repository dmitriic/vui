function! vui#component#text#new(content)
    let obj          = vui#component#base#new()
    let obj._type    = "text"
    let obj._lines   = []

    call add(obj._lines, a:content)
    call obj.set_width(strwidth(a:content))

    unlet obj.set_width
    unlet obj.set_height

    function! obj.render(render_buffer)
        let l:x = self.get_global_x()
        let l:y = self.get_global_y()
        for l:i in range(0, len(self._lines) - 1)
            call a:render_buffer.put(l:x, l:y + l:i, self._lines[l:i])
        endfor
    endfunction

    " function! obj.get_content()
    "     return self._content
    " endfunction
    " function! obj.set_content(content)
    "     let self._content = a:content
    " endfunction

    function! obj.clear()
        let self._lines = []
        let self._width = 0
    endfunction

    function! obj.get_height()
        return len(self._lines)
    endfunction

    function! obj.add_line(content)
        let l:lines = split(a:content, "\n")

        for l:i in range(0, len(l:lines) - 1)
            call add(self._lines, l:lines[l:i])
            let l:width = strwidth(l:lines[l:i])
            if l:width > self.get_width()
                let self._width = l:width
            endif
        endfor

        call self.emit('changed', self)
    endfunction

    function! obj.set_text(content)
        call self.clear()
        call self.add_line(a:content)
    endfunction

    function! obj.remove_line(index)
        let l:line remove(self._lines, a:index)
        call self.update_width()

        call self.emit('changed', self)

        return l:line
    endfunction

    function! obj.replace_line(index, new_content)
        if a:index >= len(self._lines)
            return
        endif

        let l:old_line           = self._lines[a:index]
        let self._lines[a:index] = a:new_content

        call self.emit('changed', self)

        return l:old_line
    endfunction

    function! obj.update_width()
        let l:width = 0;
        for l:i in range(0, len(self._lines) - 1)
            let l:size = strwidth(self._lines[l:i])
            if l:size > l:width
                let l:width = l:size
            endif
        endfor
        let self._width = l:width

        call self.emit('changed', self)
    endfunction

    return obj
endfunction
