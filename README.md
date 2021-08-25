# fzf-sc

Use the power of [fzf](https://github.com/junegunn/fzf.vim) to get the best out of [SuperCollider](https://supercollider.github.io/).

## Requirements

- [fzf.vim](https://github.com/junegunn/fzf.vim)
- [scnvim](https://github.com/davidgranstrom/scnvim)
- Nvim >= v0.5

## Installation

For vim-plug users, add this to your init.vim:

`Plug 'madskjeldgaard/fzf-sc'`

Then run `:PlugInstall`.

## Setup

Somewhere in your init.vim, add:
`lua require'fzf-sc'`

## Requirements
- Unix or linux system
- Nvim >= v0.5

## Available commands
`:QuarksInstall`

Fetch quarks directory and install selected

`:QuarksUninstall`

List installed quarks and remove selected

`:SCPlaySynth`

List added SynthDefs and play the selected

`:NodeProxyStop`

List active nodeproxies and stop selected

`:NodeProxyPlay`

List inactive nodeproxies and play selected

`:PdefPlay`

List inactive Pdefs and play selected

`:PdefStop`

List active Pdefs and play selected

`:CurrentEnvironment`

List environment variables and post the contents of selected

`:Scale`

List all scales and play through the selected scale using a pattern
