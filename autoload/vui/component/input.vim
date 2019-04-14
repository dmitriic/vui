function! vui#component#input#new(width)
    let obj              = vui#component#base#new()
    let obj._type        = "input"
    let obj._placeholder = ""
    let obj._value       = ""

    call obj.set_width(a:width)
    call obj.set_height(1)
    call obj.set_focusable(1)

    unlet obj.set_height

    function! s:on_action(element)
        let l:input          = input(a:element._placeholder, a:element._value)
        let a:element._value = l:input

        call a:element.emit('text_change', a:element)
        call a:element.emit('change', a:element)
    endfunction

    call obj.on('action', function('s:on_action'))

    function! obj.render(render_buffer)
        let l:x = self.get_global_x()
        let l:y = self.get_global_y()


        let l:length = len(self._value)

        let l:display = l:length > self.get_width() ? self._value[0:self.get_width() - 1] : self._value

        call a:render_buffer.put(l:x, l:y, l:display)
    endfunction

    function! obj.set_placeholder(placeholder)
        let self._placeholder = a:placeholder
    endfunction

    function! obj.get_placeholder()
        return self._placeholder
    endfunction

    function! obj.get_value()
        return self._value
    endfunction

    function! obj.set_value(value)
        let self._value = a:value
    endfunction

    return obj
endfunction

