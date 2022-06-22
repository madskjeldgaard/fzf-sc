if !has('nvim-0.7')
    echohl Error
    echomsg "Fzf-sc is only available for Neovim versions 0.7 and above"
    echohl clear
    finish
endif

if exists('g:loaded_fzf_sc') | finish | endif
let g:loaded_fzf_sc = 1
