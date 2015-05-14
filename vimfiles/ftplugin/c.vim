set ts=4                        "tab���ո����
set expandtab                   "tabתΪ�ո� 

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

nnoremap <buffer> <m-g>s       :cclose<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <m-g>g       :cclose<CR>:cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <m-g>c       :cclose<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <m-g>t       :cclose<CR>:cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <m-g>e       :cclose<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <m-g>f       :cclose<CR>:cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <buffer> <m-g>i       :cclose<CR>:cs find i <C-R>=expand("<cfile>")<CR><CR>
nnoremap <buffer> <m-g>d       :cclose<CR>:cs find d <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <m-g>s  <Esc>:cclose<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <m-g>g  <Esc>:cclose<CR>:cs find g <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <m-g>c  <Esc>:cclose<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <m-g>t  <Esc>:cclose<CR>:cs find t <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <m-g>e  <Esc>:cclose<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <m-g>f  <Esc>:cclose<CR>:cs find f <C-R>=expand("<cfile>")<CR><CR>
inoremap <buffer> <m-g>i  <Esc>:cclose<CR>:cs find i <C-R>=expand("<cfile>")<CR><CR>
inoremap <buffer> <m-g>d  <Esc>:cclose<CR>:cs find d <C-R>=expand("<cword>")<CR><CR>

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
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++"
    endif

    if(executable('cscope') && has("cscope") )
        if(MySys()!='windows')
            silent! execute "!find . -name '*.hpp' -o -name '*.h' -o -name '*.c' -o -name '*.cpp' > cscope.files"
        else
            silent! execute "!dir /s/b *.hpp *.c,*.cpp,*.h,* >> cscope.files"
        endif
            silent! execute "!cscope -bq"
        execute "normal :"

        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction

if MySys() == 'windows'
	setlocal tags+=C:/Program\\\ Files/Microsoft\\\ Visual\\\ Studio\\\ 11.0/VC/include/tags
	setlocal tags+=C:/Program\\\ Files/MySQL/MySQL\\\ Server\\\ 5.0/include/tags
    setlocal path+=C:/Program\\\ Files/Microsoft\\\ Visual\\\ Studio\\\ 11.0/VC/include
    setlocal path+=C:/Program\\\ Files/MySQL/MySQL\\\ Server\\\ 5.0/include
    setlocal path+=C:/Program\\\ Files/Lua/5.1/include
else
    setlocal tags+=~/tags/tags.linux
    setlocal path+=/usr/local/include
endif

"====================================================
" fold
"====================================================
setlocal foldmethod=indent
setlocal foldmethod=syntax
" setlocal foldlevel=1
setlocal foldtext=v:folddashes.substitute(getline(v:foldstart),'/\\*\\\|\\*/\\\|{{{\\d\\=','','g')

function! OpenZFAndSetmap()
    :normal zR

    if MySys() == 'windows'
        :nnoremap <buffer> <leader>sf :vsp D:\Vim\vimfiles\ftplugin\cpp.vim<CR>
        :inoremap <buffer> <leader>sf <C-[>:vsp D:\Vim\vimfiles\ftplugin\cpp.vim<CR>
    else
        :nnoremap <buffer> <leader>sf :vsp ~/.vim/ftplugin/cpp.vim<CR>
        :nnoremap <buffer> <leader>sf <C-[>:vsp ~/.vim/ftplugin/cpp.vim<CR>
    endif
endfunction

autocmd BufWinEnter *.cpp,*.h  silent call OpenZFAndSetmap()

inoremap <buffer> <leader>te <C-O>:Vexplore<CR> 
nnoremap <buffer> <leader>te :Vexplore<CR>
inoreabbrev <buffer> /**** /***************************************************/<CR>/***************************************************/<UP>

inoremap <buffer> <M-;> <C-O>A;
inoremap <buffer> <C-;> <C-O>A;

"====================================================
" for mymistake
"====================================================
iabbrev <buffer> Include include
iabbrev <buffer> inlcude include

