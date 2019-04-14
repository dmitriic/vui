function! vui#component#toggle#new(text)
    let obj          = vui#component#base#new()
    let obj._type    = "toggle"
    let obj._checked = 0
    let obj._text    = a:text
    let obj._display = ""

    call obj.set_height(1)
    call obj.set_focusable(1)

    unlet obj.set_height

    call vui#util#set_default_value('g:vui_toggle_checked', '[x]')
    call vui#util#set_default_value('g:vui_toggle_unchecked', '[ ]')

    function! s:on_action(element)
        call a:element.toggle_checked()
        call a:element.emit('change', a:element)
    endfunction

    call obj.on('action', function('s:on_action'))

    function! obj.update(screen)
        let l:toggle_size = max([len(g:vui_toggle_checked), len(g:vui_toggle_unchecked)])

        call self.set_width(l:toggle_size + len(self._text) + 1)
        let self._display  = self._checked ? g:vui_toggle_checked : g:vui_toggle_unchecked
        let self._display .= ' ' . self._text
    endfunction

    function! obj.render(render_buffer)
        let l:x = self.get_global_x()
        let l:y = self.get_global_y()

        call a:render_buffer.put(l:x, l:y, self._display)
    endfunction

    function! obj.get_text()
        return self._text
    endfunction

    function! obj.set_text(text)
        let self._text = a:text
    endfunction

    function! obj.toggle_checked()
        call self.set_checked(self._checked ? 0 : 1)
    endfunction

    function! obj.is_checked()
        return self._checked
    endfunction

    function! obj.set_checked(checked)
        let l:changed = !vui#util#is_equal(a:checked, self._checked)

        let self._checked = a:checked

        call self.emit_if(l:changed, 'changed', self)
    endfunction

    return obj
endfunction
