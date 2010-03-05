" Show svn diff on footer.
" Language: svn
" Version:  0.2.0
" Author:   thinca <thinca+vim@gmail.com>
" License:  Creative Commons Attribution 2.1 Japan License
"           <http://creativecommons.org/licenses/by/2.1/jp/deed.en>
" URL:      http://gist.github.com/307495
"
" ChangeLog: {{{
" 0.2.0   2010-03-05
"         - Use :read! instead of system() to detect encoding automatically.
"         - Check whether b:current_syntax exists.
"
" 0.1.0   2010-02-19
"         - Initial version.
" }}}

function! s:get_file_list()
  let list = []
  silent global/^M\>/call add(list, substitute(getline('.'), '^M\s*\(.*\)', '\1', ''))
  return list
endfunction



function! s:show_diff()
  let list = s:get_file_list()
  if empty(list)
    return
  endif

  let q = '"'
  call map(list, 'q . substitute(v:val, "!", "\\!", "g") . q')

  $put =[]

  let lang = $LANG
  let $LANG = 'C'
  execute '$read !svn diff' join(list, ' ')
  let $LANG = lang

  if exists('b:current_syntax')
    let current_syntax = b:current_syntax
    unlet! b:current_syntax
  endif
  syntax include @svnDiff syntax/diff.vim
  syntax region svnDiff start="^=\+$" end="^\%$" contains=@svnDiff
  if exists('current_syntax')
    let b:current_syntax = current_syntax
  endif

  global/^Index:/delete _

  1
endfunction

call s:show_diff()
