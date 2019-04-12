function! vui#node#new()
    let obj = {}

    let obj._events   = {}
    let obj._type     = 'node'
    let obj._is_node  = 1
    let obj._children     = []


    function! obj.on(event, callback)
        if !has_key(self._events, a:event)
            let self._events[a:event] = []
        endif
        call add(self._events[a:event], a:callback)
    endfunction

    function! obj.off(event, ...)
        if a:0 == 1
            if !has_key(self._events, a:event)
                return
            endif

            let l:index = -1
            for l:i in range(0, len(self._events[a:event]))
                if self._events[a:event][l:i] == a:1
                    let l:index = l:i
                    break
                endif
            endfor
            if l:index >= 0
                call remove(self._events[a:event], l:index)
            endif

        else
            call remove(self._events, a:event)
        endif
    endfunction

    function! obj.emit(event, payload)
        if !has_key(self._events, a:event)
            return
        endif
        let l:i = 0
        while l:i < len(self._events[a:event])
            let Callback = function(self._events[a:event][i], self)
            let l:result = Callback(a:payload)

            if l:result
                break
            endif

            let l:i += 1
        endwhile
    endfunction

    function! obj.add_child(node)
        if !has_key(a:node, "_is_component") || !a:node._is_component
            return
        endif
        call a:node.set_parent(self)
        call add(self._children, a:node)
    endfunction

    function! obj.has_parent()
        if !has_key(self._parent, "_is_component") || !self._parent._is_component
            return 0
        endif
        return 1
    endfunction

    function! obj.get_parent()
        return self._parent
    endfunction

    function! obj.set_parent(parent)
        let self._parent = a:parent
    endfunction

    function! obj.remove_child(node)
        if !has_key(a:node, "_is_component") || !a:node._is_component
            return
        endif
        " TODO
    endfunction

    return obj
endfunction
