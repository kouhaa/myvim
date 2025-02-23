"===============文字コードに関する設定================
"ファイル読み込み時の文字コードの設定
set encoding=utf-8

"Vim script内でマルチバイト文字を使う際の設定
scriptencoding uft-8

" 保存時の文字コード
set fileencoding=utf-8

" 読み込み時の文字コードの自動判別. 左側が優先される
set fileencodings=ucs-boms,utf-8,euc-jp,cp932

" 改行コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac

" □や○文字が崩れる問題を解決
set ambiwidth=double
"=====================================================




"===============タブやインデントに関する設定===============
"タブ入力を複数の空白文字に置き換える
set expandtab

"画面上でタブ文字が占める幅を規定
set tabstop=2

"連続した空白に対してtab_key やbackspace_keyでカーソルが動く幅を規定
set softtabstop=2

"改行時に前の行のインデントを継続させる
set autoindent

"改行時に前の行の構文をチェックし次の行のインデントを増減させる
set smartindent

"smartindentで増減する幅を規定
set shiftwidth=2

" インデントを設定
autocmd FileType coffee     setlocal sw=2 sts=2 ts=2 et
"============================================================




"==================== 検索系============================
"検索結果をハイライト
"set hlsearch
set incsearch

"検索結果に大文字小文字を区別しない
set ignorecase

"検索文字に大文字が含まれていたら、大文字小文字を区別する
set smartcase

"----------検索対象から除外するファイルを指定---------
let Grep_Skip_Dirs = '.svn .git'  "無視するディレクトリ
let Grep_Default_Options = '-I'   "バイナルファイルがgrepしない
let Grep_Skip_Files = '*.bak *~'  "バックアップファイルを無視する
"-----------------------------------------------------

":cn,:cpを、[q、]q にバインディング
nnoremap [q :cprevious<CR>   " 前へ
nnoremap ]q :cnext<CR>       " 次へ
nnoremap [Q :<C-u>cfirst<CR> " 最初へ
nnoremap ]Q :<C-u>clast<CR>  " 最後へ
"======================================================




"====================syntax系=========================
syntax enable
set background=dark
colorscheme desert

"シンタックスハイライト有効
syntax on
"=======================================================




"======================カーソル系========================
"カーソルの左右移動で行末から次の行の行頭への移動が可能になる
set whichwrap=b,s,h,l,<,>,[,],~

"横線を入れる
set cursorline
highlight Cursorline term=reverse cterm=reverse guifg=black guibg=#c2bfa5

"行番号を表示する
set number

" 現在の行を強調表示（縦）
set cursorcolumn

"INSERTモードのときだけ横線解除
"augroup set_cursorline
"  autocmd!
"  autocmd InsertEnter,InsertLeave * set cursorline!  "redraw!
"augroup END

"全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /　/

" タイトルをウインドウ枠に表示する
set title

"カーソルが何行目の何列目に置かれているかを表示する
set ruler

" backspace使用できるように
set backspace=indent,eol,start
"========================================================





"=======================コピー&ペースト系=================
" クリップボード
set clipboard=unnamed,autoselect

"----------コピーした際に自動インデントでズレない設定----
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif
"--------------------------------------------------------

"==========================================================




"======================ファイル操作系=====================
"VimFilter起動時からファイル操作が出来る設定(切り替えはgs)
let g:vimfiler_as_default_explorer = 1
"=========================================================




"====================その他設定===========================
"自動でswpファイル作らない
set noswapfile

"自動補完(タブで移動)
set wildmenu

"保存するコマンド履歴の数を設定
set history=5000

" vimにcoffeeファイルタイプを認識させる
au BufRead,BufNewFile,BufReadPre *.coffee   set filetype=coffee

"Ctags
set tags+=~/.tags
"==========================================================




"===================独自キーバインド========================
"ノーマルモードのEnterで改行追加
noremap <CR> o<ESC>
"===========================================================




"==================マウスの有効化====================
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif
"====================================================




"==================tab移動の設定===========================
"---t1,t2...でタブ移動,tcでタブ新規作成,txでタブ閉じ-------
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears

    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]t :tablast <bar> tabnew<CR>
" tt 新しいタブを一番右に作る
map <silent> [Tag]q :tabclose<CR>
" tq タブを閉じる
map <silent> <S-Right> :tabnext<CR>
" tn 次のタブ
map <silent> <S-Left> :tabprevious<CR>
" tp 前のタブ
"==============================================================




"====================== Neobundle ===========================
" bundleで管理するディレクトリを指定
set runtimepath+=~/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" neobundle自体をneobundleで管理
NeoBundleFetch 'Shougo/neobundle.vim'

"---------NeoBundleで管理するプラグイン達----------
"カラースキーム
NeoBundle 'tomasr/molokai'
"ディレクトリツリーの表示
NeoBundle 'scrooloose/nerdtree'
"ファイル名でファイルを検索
NeoBundle "ctrlpvim/ctrlp.vim"
"インデントを蛍光カラーで表示
NeoBundle 'nathanaelkane/vim-indent-guides'
"coffeescriptを認識させる
NeoBundle 'kchmck/vim-coffee-script'
" ステータスラインの表示内容強化
NeoBundle 'itchyny/lightline.vim'
" 末尾の全角と半角の空白文字を赤くハイライト
NeoBundle 'bronson/vim-trailing-whitespace'
"grep機能を使いやすくする
":Rgrep {word} で検索 [q: 前へ,  ]q: 次へ, :cc N{番号}
NeoBundle 'vim-scripts/grep.vim'
"vimのIDE化
NeoBundle 'Shougo/unite.vim'
"ディレクトリツリーをタブ開いた瞬間に表示
NeoBundle 'jistr/vim-nerdtree-tabs'
"インデントを可視化
NeoBundle 'Yggdroot/indentLine'
"カーソル移動を楽に
NeoBundle 'easymotion/vim-easymotion'
"括弧移動を拡張
NeoBundle 'tmhedberg/matchit'
"helpの日本語化
NeoBundle 'vim-jp/vimdoc-ja'
"「=」入力時に自動的にスペースを確保する
"NeoBundle 'kana/vim-smartchr'
"HTML/CSSの作成簡略化 <C-y>, でタグ展開
NeoBundle 'mattn/emmet-vim'
"コメントアウト gccでカレント行 gcで選択行
NeoBundle 'tomtom/tcomment_vim'
"指定範囲を楽に囲む 選択範囲を、S＋囲むもの
NeoBundle 'tpope/vim-surround'
"true/false など、対になるものを:Switchで切り替え
NeoBundle 'AndrewRadev/switch.vim'
"日本語の単語移動を分節単位に
NeoBundle 'deton/gist:5138905'
"ファイルが保存されたタイミングでCtag自動更新
NeoBundle 'soramugi/auto-ctags.vim'
"vimのセッション保存
NeoBundle 'tpope/vim-obsession'
"vimの画面分割を簡易化 C+eで開始 hjklで画面サイズ変更
NeoBundle 'simeji/winresizer'
"ESLintをプロジェクト毎にローカルで使う
NeoBundle 'scrooloose/syntastic'
NeoBundle 'pmsorhaindo/syntastic-local-eslint.vim'
"JSのSyntax関連
NeoBundle 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx', 'html', 'vue'] }
NeoBundle 'othree/yajs.vim'
NeoBundle 'othree/html5.vim'
NeoBundle 'slim-template/vim-slim'
NeoBundle 'posva/vim-vue'
" コードの自動補完
NeoBundle 'Shougo/neocomplete.vim'
" スニペットの補完機能
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle "Shougo/neosnippet"
" スニペット集
NeoBundle 'Shougo/neosnippet-snippets'
"--------------------------------------------------



"-----------------自動補完の設定--------------------
if neobundle#is_installed('neocomplete.vim')
    " Vim起動時にneocompleteを有効にする
    let g:neocomplete#enable_at_startup = 1
    " smartcase有効化. 大文字が入力されるまで大文字小文字の区別を無視する
    let g:neocomplete#enable_smart_case = 1
    " 3文字以上の単語に対して補完を有効にする
    let g:neocomplete#min_keyword_length = 3
    " 区切り文字まで補完する
    let g:neocomplete#enable_auto_delimiter = 1
    " 1文字目の入力から補完のポップアップを表示
    let g:neocomplete#auto_completion_start_length = 1
    " バックスペースで補完のポップアップを閉じる
    inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"
    " エンターキーで補完候補の確定. スニペットの展開もエンターキーで確定・・・・・・②
    imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
    " タブキーで補完候補の選択. スニペット内のジャンプもタブキーでジャンプ・・・・・・③
    imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"
endif
"----------------------------------------------------



"---------------NERDTreeの設定---------------------
" 隠しファイルをデフォルトで表示させる
let NERDTreeShowHidden = 1

" デフォルトでツリーを表示させる
let g:nerdtree_tabs_open_on_console_startup=1

"<C-n>でNERDTreeTabsToggleを呼び出す設定
map <C-n> <plug>NERDTreeTabsToggle<CR>
"-------------------------------------------------



"--------------indent guideの設定-----------------
set list listchars=tab:\¦\
let g:indentLine_color_term = 111
let g:indentLine_color_gui = '#708090'
"-------------------------------------------------


"独自スニペット用のディレクトリ設定
let g:neosnippet#snippets_directory='~/.vim/bundle/neosnippet-snippets/snippets/'

"snippets展開とplaceholderの移動をC-kに指定
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
"------------------------------------------------------



"----------------smartchrの設定-----------------------
"=を打ち込んだ回数でスペースの幅を規定
"inoremap <expr> = smartchr#one_of(' = ', ' == ', ' === ', '=')
"-----------------------------------------------------



"--------------Auto-Ctagsの設定---------------------
let g:auto_ctags = 1
"-----------------------------------------------------




"--------------ESLintの設定---------------------
let g:syntastic_javascript_checkers=['eslint']
" エラー行に sign を表示
let g:syntastic_enable_signs = 1
" location list を常に更新
let g:syntastic_always_populate_loc_list = 0
" location list を常に表示
let g:syntastic_auto_loc_list = 0
" ファイルを開いた時にチェックを実行する
let g:syntastic_check_on_open = 1
" :wq で終了する時もチェックする
let g:syntastic_check_on_wq = 0
"-----------------------------------------------------



"--------------- ステータスラインの設定---------------
set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
"---------------------------------------------------------

call neobundle#end()

" Required:
filetype plugin indent on

" 未インストールのプラグインがある場合、vimrc起動時にインストール
NeoBundleCheck
"===========================================================
