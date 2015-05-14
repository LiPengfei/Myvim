set ts=4                        "tab���ո����
set expandtab                   "tabתΪ�ո� 

function! CheckPythonSyntax() 
    let mp = &makeprg 
    let ef = &errorformat 
    let exeFile = expand("%:t") 
    setlocal makeprg=python\ -u 
    set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m 
    silent make % 
    clist 
    let &makeprg     = mp 
    let &errorformat = ef 
endfunction

nnoremap <buffer> <C-F4> <Esc>:call CheckPythonSyntax()<CR>
inoremap <buffer> <C-F4> <Esc>:call CheckPythonSyntax()<CR>

inoremap <buffer> " ""<Left>
inoremap <buffer> ' ''<left>
inoremap <buffer> ( ()<left>
inoremap <buffer> [ []<left>
inoremap <buffer> < <
inoremap <buffer> <leader>sf <C-[>:e d:\Vim\vimfiles\ftplugin\python.vim<CR>
nnoremap <buffer> <leader>sf :e d:\Vim\vimfiles\ftplugin\python.vim<CR>

nnoremap <buffer> <C-F1> :call Do_CsTag()<CR>
inoremap <buffer> <C-F1> <Esc>:call Do_CsTag()<CR><CR>a

" for cscope 
"s: ����C���Է��ţ������Һ��������ꡢö��ֵ�ȳ��ֵĵط�
"g: ���Һ������ꡢö�ٵȶ����λ�ã�����ctags���ṩ�Ĺ���
"d: ���ұ��������õĺ���
"c: ���ҵ��ñ������ĺ���
"t: ����ָ�����ַ���
"e: ����egrepģʽ���൱��egrep���ܣ��������ٶȿ����
"f: ���Ҳ����ļ�������vim��find����
"i: ���Ұ������ļ����ļ�

nnoremap <buffer> <c-@>s       :cclose<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>:botright cw<CR>
nnoremap <buffer> <c-@>g       :cclose<CR>:cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <c-@>c       :cclose<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>:botright cw<CR>
nnoremap <buffer> <c-@>t       :cclose<CR>:cs find t <C-R>=expand("<cword>")<CR><CR>:botright cw<CR>
nnoremap <buffer> <c-@>e       :cclose<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>:botright cw<CR>
nnoremap <buffer> <c-@>f       :cclose<CR>:cs find f <C-R>=expand("<cfile>")<CR><CR>:botright cw<CR>
nnoremap <buffer> <c-@>i       :cclose<CR>:cs find i <C-R>=expand("<cfile>")<CR><CR>:botright cw<CR>
nnoremap <buffer> <c-@>d       :cclose<CR>:cs find d <C-R>=expand("<cword>")<CR><CR>:botright cw<CR>
inoremap <buffer> <c-@>s  <Esc>:cclose<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>:botright cw<CR>
inoremap <buffer> <c-@>g  <Esc>:cclose<CR>:cs find g <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <c-@>c  <Esc>:cclose<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>:botright cw<CR>
inoremap <buffer> <c-@>t  <Esc>:cclose<CR>:cs find t <C-R>=expand("<cword>")<CR><CR>:botright cw<CR>
inoremap <buffer> <c-@>e  <Esc>:cclose<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>:botright cw<CR>
inoremap <buffer> <c-@>f  <Esc>:cclose<CR>:cs find f <C-R>=expand("<cfile>")<CR><CR>:botright cw<CR>
inoremap <buffer> <c-@>i  <Esc>:cclose<CR>:cs find i <C-R>=expand("<cfile>")<CR><CR>:botright cw<CR>
inoremap <buffer> <c-@>d  <Esc>:cclose<CR>:cs find d <C-R>=expand("<cword>")<CR><CR>:botright cw<CR>

function! Do_CsTag()
    let dir = getcwd()
    if filereadable("tags")
        if(MySys()=='windows')
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif

    if has("cscope")
        silent! execute "cs kill -1"
    endif

    if filereadable("cscope.files")
        if(MySys()=='windows')
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif

    if filereadable("cscope.out")
        if(MySys()=='windows')
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif

    if(executable('ctags'))
        " silent! execute "!ctags -R --python-kinds=cfmvi --fields=afiksSzt --extra=+qf --language-force=python"
        silent! execute "!ctags -R --python-kinds=cm --extra=+qf --language-force=python"
    endif

    if(executable('cscope') && has("cscope") )
        if(MySys()!='windows')
            silent! execute "!find . -name '*.py' -o -name '*.pyw' > cscope.files"
        else
            silent! execute "!dir /s/b *.py,*.pyw >> cscope.files"
        endif
            silent! execute "!cscope -bq"
        execute "normal :"

        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction
