if !has('nvim-0.5')
    echohl Error
    echomsg "Fzf-sc is only available for Neovim versions 0.5 and above"
    echohl clear
    finish
endif

if exists('g:loaded_fzf_sc') | finish | endif
let g:loaded_fzf_sc = 1
