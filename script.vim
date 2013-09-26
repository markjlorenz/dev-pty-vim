au BufWritePost * silent wviminfo! tmp/viminfo
au BufWritePost * silent mks!      tmp/session.vim
au FileChangedShell * ruby Mark.run
