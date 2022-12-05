" 当打开nvim时，若没有下载vim-plug则自动下载
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


" 始终都会加载的配置项
let mapleader=" "
" 使用系统剪切板
set clipboard=unnamed

" 自动切换输入法
if executable('im-select')
    autocmd InsertLeave * :call system("im-select com.apple.keylayout.ABC")
    autocmd CmdlineLeave * :call system("im-select com.apple.keylayout.ABC")
endif

" ----- settings ----
if exists('g:vscode')
    " ----- Plug -----
    call plug#begin('~/.config/nvim/autoload/')
        " 快速跳转
        Plug 'asvetliakov/vim-easymotion'
        " 包裹修改
        Plug 'tpope/vim-surround'
    call plug#end()
    " 切换行注释
    nnoremap gc <Cmd>call VSCodeNotify('editor.action.commentLine')<CR>
    " 切换块注释
    nnoremap gC <Cmd>call VSCodeNotify('editor.action.blockComment')<CR>
    " 展开所有折叠
    nnoremap zR <Cmd>call VSCodeNotify('editor.unfoldAll')<CR>
    " 关闭所有折叠
    nnoremap zM <Cmd>call VSCodeNotify('editor.foldAll')<CR>
    " 展开当下折叠
    nnoremap zo <Cmd>call VSCodeNotify('editor.unfold')<CR>
    " 关闭当下折叠
    nnoremap zc <Cmd>call VSCodeNotify('editor.fold')<CR>
    " 切换当下折叠
    nnoremap zz <Cmd>call VSCodeNotify('editor.toggleFold')<CR>
    " 转到文件中上一个问题
    nnoremap g[ <Cmd>call VSCodeNotify('editor.action.marker.prevInFiles')<CR>
    " 转到文件中下一个问题
    nnoremap g] <Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>
    " 用H替换掉^
    noremap H ^
    " 用L替换掉$
    noremap L $
    " 使用vscode的undo替换nvim的undo
    nnoremap u <Cmd>call VSCodeNotify('undo')<CR>
    " easymotion相关配置
    let g:EasyMotion_smartcase = 0
    " easymotion前缀 leader leader
    map <Leader> <Plug>(easymotion-prefix)
    " 其他键位绑定
    map <Leader>l <Plug>(easymotion-lineforward)
    map <Leader>j <Plug>(easymotion-j)
    map <Leader>k <Plug>(easymotion-k)
    map <Leader>h <Plug>(easymotion-linebackward)

else
    " 以正常模式启动nvim时加载的配置项
    " 显示行号
    set number
    " 设置相对行号
    set relativenumber
    " 设置行宽
    set textwidth=80
    " 设置自动换行
    set wrap
    " 是否显示状态栏
    set laststatus=2
    " 语法高亮
    syntax on
    " 支持鼠标
    set mouse=a
    " 设置编码格式
    set encoding=utf-8
    " 启用256色
    set t_Co=256
    " 开启文件类型检查
    filetype indent on
    " 设置自动缩进
    set autoindent
    " 设置tab缩进数量
    set tabstop=4
    " 设置>>与<<的缩进数量
    set shiftwidth=4
    " 将缩进转换为空格
    set expandtab
    " 自动高亮匹配符号
    set showmatch
    " 自动高亮匹配搜索结果
    set nohlsearch
    " 开启逐行搜索，也就是说按下一次按键就继续一次搜索
    set incsearch
    " 开启类型检查
    " set spell spelllang
    " 开启命令补全
    set wildmenu
    " 不创建备份文件
    set nobackup
    " 不创建交换文件
    set noswapfile
    " 多窗口下光标移动到其他窗口时自动切换工作目录
    set autochdir
    " ----- Plug -----
    call plug#begin('~/.config/nvim/autoload/')
        " 快速跳转
        Plug 'easymotion/vim-easymotion'
        " 包裹修改
        Plug 'tpope/vim-surround'
        " vim中文文档
        Plug 'yianwillis/vimcdoc'
        " 颜色插件
        Plug 'theniceboy/vim-deus'
        " 根据内容自动获取文件类型
        Plug 'Shougo/context_filetype.vim'
        " 自动进行注释
        Plug 'tyru/caw.vim'
        " 包裹修改
        Plug 'tpope/vim-surround'
        " 多光标模式操作
        Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    call plug#end()
    " -- ctrl+/设置为打开、关闭注释
    if has('win32')
        nmap <C-/> gcc
        vmap <C-/> gcc
    else
        nmap <C-_> gcc
        vmap <C-_> gcc
    endif
    "按键映射前缀: <leader>v。
    let g:VM_maps = {}                 "取消默认按键映射。
    let g:VM_maps['Find Under'] = 'gb' "进入多光标模式并选中光标下字符串。
endif
