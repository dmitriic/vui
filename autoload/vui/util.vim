function! vui#util#replace_string(original_string, string_to_replace, position)
    let l:string_to_replace = a:string_to_replace
    let l:original_string   = a:original_string
    let l:string_length     = strwidth(l:original_string)

    if (a:position > l:string_length)
        let l:original_string .= repeat(' ', a:position - l:string_length)
        let l:string_length    = strwidth(l:original_string)
    endif

    let l:string_to_replace_length = strwidth(l:string_to_replace)
    let l:character_before         = a:position
    let l:character_after          = a:position + l:string_to_replace_length

    if (l:character_after > l:string_length)
        let l:original_string .= repeat(' ', l:character_after - l:string_length)
        let l:string_length    = strwidth(l:original_string)
    endif

    if (l:character_before < 0)
        let l:string_to_replace        = l:string_to_replace[abs(l:character_before):]
        let l:string_to_replace_length = strwidth(l:string_to_replace)
        let l:character_after          = l:character_after + l:character_before
        let l:character_before         = 0
    endif

    if (l:character_after < 0)
        return a:original_string
    endif

    if (l:character_after > l:string_length)
        let l:character_after = l:string_length - 1
    endif

    return substitute(
        \ l:original_string,
        \ '^.\{' . l:character_before . '\}\zs.\{' . l:string_to_replace_length . '\}\ze',
        \ l:string_to_replace,
        \ ''
    \)
    " let l:string_before = l:character_before  == 0 ? "" : strpart(l:original_string, 0, l:character_before - 1)
    " let l:string_after  = l:character_after   >= (l:string_length - 1) ? "" : strpart(l:original_string, l:character_after)
    " " let l:old_string    = l:original_string[l:character_before:l:character_after-1]

    " return l:string_before . l:string_to_replace . l:string_after
endfunction

function! vui#util#set_default_value(variable_name, default_value)
    if !exists(a:variable_name)
        " TODO: make it more robust
        execute "let " . a:variable_name . '="' . escape(a:default_value, '"') . '"'
    endif
endfunction
