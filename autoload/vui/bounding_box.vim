function! vui#bounding_box#new(x, y, width, height)
    let obj = {}

    let obj._x      = a:x
    let obj._y      = a:y
    let obj._width  = a:width
    let obj._height = a:height
    let obj._type   = 'bounding_box'

    function! obj.get_x()
        return self._x
    endfunction

    function! obj.set_x(x)
        let self._x = a:x
    endfunction

    function! obj.get_y()
        return self._y
    endfunction

    function! obj.set_y(y)
        let self._y = a:y
    endfunction

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

    function! obj.intersects(other)
        if !has_key(a:other, "_type") || a:other._type != 'bounding_box'
            return 0
        endif

        let l:self_x_start = self.get_x()
        let l:self_x_end   = self.get_x() + self.get_width() - 1
        let l:self_y_start = self.get_y()
        let l:self_y_end   = self.get_y() + self.get_height() - 1

        let l:other_x_start = a:other.get_x()
        let l:other_x_end   = a:other.get_x() + a:other.get_width() - 1
        let l:other_y_start = a:other.get_y()
        let l:other_y_end   = a:other.get_y() + a:other.get_height() - 1

        if l:self_x_end < l:other_x_start || l:other_x_end < l:self_x_start
            return 0
        endif

        if l:self_y_end < l:other_y_start || l:other_y_end < l:self_y_start
            return 0
        endif

        return 1
    endfunction


    return obj
endfunction
