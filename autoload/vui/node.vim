function! vui#node#new()
    let obj = {}

    let obj._width    = 0
    let obj._height   = 0
    let obj._events   = {}
    let obj._type     = 'node'
    let obj._is_node  = 1

    function! obj.get_width()
        return self._width
    endfunction

    function! obj.set_width(width)
        let self._width = a:width
    endfunction

    function! obj.get_height()
        return self._height
    endfunction

    function! obj.set_height(height)
        let self._height = a:height
    endfunction

    function! obj.get_size()
        let l:size = { 'width': self._width, 'height': self._height }
        return l:size
    endfunction

    function! obj.on(event, callback)
        if !has_key(self._events, a:event)
            let self._events[a:event] = []
        endif
        call add(self._events[a:event], a:callback)
    endfunction

    function! obj.off(event, ...)
        if a:0 == 1
            if has_key(self._events, a:event)
                let self._events[a:event] = []
            endif
        else
            let l:i = 0
            while l:i < a:0
                let l:callback = 'a:' . l:i
                call remove(self._events[a:event], {l:callback})
                let l:i += 1
            endwhile
        endif
    endfunction

    function! obj.emit(event, payload)
        if !has_key(self._events, a:event)
            return
        endif
        let l:i = 0
        while l:i < len(self._events[a:event])
            let Callback = function(self._events[a:event][i])
            call Callback(a:payload)

            let l:i += 1
        endwhile
    endfunction

    return obj
endfunction
