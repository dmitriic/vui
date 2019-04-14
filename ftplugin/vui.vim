nnoremap <buffer> <esc> <nop>
nnoremap <buffer> i <nop>
nnoremap <buffer> I <nop>
nnoremap <buffer> o <nop>
nnoremap <buffer> O <nop>
nnoremap <buffer> a <nop>
nnoremap <buffer> A <nop>
nnoremap <buffer> v <nop>
nnoremap <buffer> V <nop>
nnoremap <buffer> <C-v> <nop>
nnoremap <buffer> p <nop>
nnoremap <buffer> P <nop>
nnoremap <buffer> f <nop>
nnoremap <buffer> F <nop>
nnoremap <buffer> / <nop>
nnoremap <buffer> ? <nop>
nnoremap <buffer> l <nop>
nnoremap <buffer> h <nop>
nnoremap <buffer> m <nop>

nnoremap <silent><buffer> q :silent bd<CR>


"TODO: Use <Plug> functions instead
function! s:focus_next()
    if !exists('b:screen')
        return
    endif

    call b:screen.focus_next_element()
endfunction

function! s:focus_first()
    if !exists('b:screen')
        return
    endif

    call b:screen.focus_first_element()
endfunction

function! s:focus_last()
    if !exists('b:screen')
        return
    endif

    call b:screen.focus_last_element()
endfunction

function! s:focus_prev()
    if !exists('b:screen')
        return
    endif

    call b:screen.focus_previous_element()
endfunction

function! s:perform_action()
    if !exists('b:screen')
        return
    endif

    call b:screen.perform_action()
endfunction

function! s:render()
    if !exists('b:screen')
        return
    endif

    call b:screen.render()
endfunction

nnoremap <silent><buffer> <Tab> :call <SID>focus_next()<CR>
nnoremap <silent><buffer> j :call <SID>focus_next()<CR>

nnoremap <silent><buffer> <S-Tab> :call <SID>focus_prev()<CR>
nnoremap <silent><buffer> k :call <SID>focus_prev()<CR>

nnoremap <silent><buffer> J :call <SID>focus_first()<CR>
nnoremap <silent><buffer> K :call <SID>focus_last()<CR>

nnoremap <silent><buffer> <CR> :call <SID>perform_action()<CR>
nnoremap <silent><buffer> <Space> :call <SID>perform_action()<CR>

nnoremap <silent><buffer> r :call <SID>render()<CR>

augroup vui_events
    autocmd! * <buffer>
    autocmd BufEnter <buffer> call <SID>render()
    autocmd BufLeave <buffer> call <SID>render()
augroup END
