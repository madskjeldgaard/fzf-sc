# fzf-sc

Use the power of [fzf](https://github.com/junegunn/fzf.vim) to get the best out of [SuperCollider](https://supercollider:github::o/):

Fuzzy search basically anything in SuperCollider and execute SuperCollider code with the result of that search.

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

## Make your own fuzzy searcher

Making your own fuzzy searcher is fairly simple. You need two things: Some supercollider code that generates an array, some supercollider code that takes the result of your choice in the fuzzy finder and does something with that knowledge. Here is an example of getting all quarks as input and then installing the chosen item in the return code. The return code is a string where `%s` is replaced with the result of the fuzzy search, eg in the example below it will be the name of the quark the user chooses.

```lua
local sc_code = [[Quarks.fetchDirectory; Quarks.all.collect{|q| q.name}]];
local supercollider_return_code = "Quarks.install(\"%s\");";

require"fzf-sc".fzf_sc_eval(sc_code, supercollider_return_code)
```
