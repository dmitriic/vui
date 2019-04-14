function! vui#component#button#new(width, text)
    let obj              = vui#component#base#new()
    let obj._type        = "button"
    let obj._placeholder = ""
    let obj._text        = a:text
    let obj._screen      = ""

    call obj.set_width(a:width)
    call obj.set_height(1)
    call obj.set_focusable(1)

    unlet obj.set_height

    function! obj.render(render_buffer)
        let l:x = self.get_global_x()
        let l:y = self.get_global_y()


        let l:length = len(self._text)

        let l:display = l:length > self.get_width() ? self._text[0:self.get_width() - 1] : self._text

        call a:render_buffer.put(l:x, l:y, l:display)
    endfunction

    function! obj.get_text()
        return self._text
    endfunction

    function! obj.set_text(text)
        let self._text = a:text
    endfunction

    return obj
endfunction


