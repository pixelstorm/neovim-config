let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/drupal_playground/kangan/web/themes/custom/KANGAN
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +6 ~/drupal_playground/kangan/web/themes/custom/KANGAN/KANGAN.theme
badd +126 ~/.config/nvim/init.vim
badd +137 ~/dynamitefrog-v3/_posts/2024-08-25-vim-cheatsheet.md
badd +395 term://~/.config/nvim//37864:/usr/local/bin/zsh
badd +731 term://~//65623:/usr/local/bin/zsh
badd +2 ~/drupal_playground/kangan/web/themes/custom/KANGAN/src/scss/blocks/_stats.scss
badd +11 ~/drupal_playground/kangan/web/themes/custom/KANGAN/templates/paragraphs/paragraph--cards.html.twig
badd +60 term://~/drupal_playground/kangan//80770:/usr/local/bin/zsh
badd +18 ~/drupal_playground/kangan/web/themes/custom/KANGAN/src/scss/blocks/_cards.scss
badd +2 ~/drupal_playground/kangan/web/themes/custom/KANGAN/src/scss/typography/_typography.scss
badd +15 ~/drupal_playground/kangan/web/themes/custom/KANGAN/src/scss/typography/_headings.scss
badd +5 ~/drupal_playground/kangan/web/themes/custom/KANGAN/src/scss/variables-site/_typography.scss
badd +2 ~/drupal_playground/kangan/web/themes/custom/KANGAN/src/scss/variables-site/_variables-site.scss
badd +67 ~/drupal_playground/kangan/web/themes/custom/KANGAN/src/scss/typography/_copy.scss
badd +57 ~/drupal_playground/kangan/web/themes/custom/KANGAN/src/scss/mixins/_mixins-typography.scss
badd +9 ~/drupal_playground/kangan/web/themes/custom/KANGAN/templates/microcontent/microcontent--card.html.twig
badd +1 ~/drupal_playground/kangan/web/themes/custom/KANGAN/templates/field/NERDTreeRenameTempBuffer
badd +79 ~/drupal_playground/kangan/web/themes/custom/KANGAN/templates/field/__off_field--paragraph--cards.html.twig
badd +33 ~/drupal_playground/kangan/web/themes/custom/KANGAN/templates/field/field.html.twig
badd +70 ~/drupal_playground/kangan/web/themes/custom/KANGAN/templates/content/node.html.twig
badd +138 ~/drupal_playground/kangan/web/themes/contrib/radix/components/card/card.twig
badd +23 ~/drupal_playground/kangan/web/themes/contrib/radix/components/field/field.twig
badd +51 ~/drupal_playground/kangan/web/themes/custom/KANGAN/templates/field/field--paragraph--cards.html.twig
badd +30 ~/drupal_playground/kangan/web/themes/contrib/radix/components/heading/heading.twig
badd +3 ~/drupal_playground/kangan/web/themes/custom/KANGAN/templates/field/field--microcontent--field-card-title.html.twig
badd +6 ~/drupal_playground/kangan/web/themes/custom/KANGAN/templates/field/field--microcontent--field-title-test.html.twig
badd +1 ~/drupal_playground/kangan/web/themes/custom/KANGAN/templates/field/field--block-content--field-block-title--basic.html.twig
badd +1 ~/drupal_playground/kangan/web/themes/custom/KANGAN/templates/field/field--block-content--field-webform--webform-ref.html.twig
badd +1 ~/drupal_playground/kangan/web/themes/custom/KANGAN/templates/field/field--paragraph--field-page-link-micro-content.html.twig
badd +1 ~/drupal_playground/kangan/web/themes/custom/KANGAN/templates/field/field--paragraph--field-team-member-micro-ref--team-member-profiles.html.twig
badd +23 term://~/drupal_playground/kangan/web/themes/custom/KANGAN/templates/field//31522:/usr/local/bin/zsh
badd +23 term://~/drupal_playground/kangan/web/themes/custom/KANGAN/templates/field//36291:/usr/local/bin/zsh
argglobal
%argdel
edit ~/drupal_playground/kangan/web/themes/custom/KANGAN/KANGAN.theme
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 31 + 98) / 196)
exe 'vert 2resize ' . ((&columns * 164 + 98) / 196)
argglobal
enew
file ~/drupal_playground/kangan/web/themes/custom/KANGAN/NERD_tree_tab_1
balt ~/drupal_playground/kangan/web/themes/custom/KANGAN/KANGAN.theme
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
wincmd w
argglobal
balt ~/.config/nvim/init.vim
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 6 - ((5 * winheight(0) + 22) / 44)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 6
normal! 0
wincmd w
exe 'vert 1resize ' . ((&columns * 31 + 98) / 196)
exe 'vert 2resize ' . ((&columns * 164 + 98) / 196)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
