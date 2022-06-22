# fzf-sc

![Fuzzy scales](assets/fzf-sc-fuzzyscales.gif)

Use the power of [fzf](https://github.com/junegunn/fzf) to get the best out of [SuperCollider](https://supercollider.github.io/):

Fuzzy search basically anything in SuperCollider and execute SuperCollider code with the result of that search.

## Requirements

- [nvim-fzf](https://github.com/vijaymarupudi/nvim-fzf)(recommended) or [fzf.vim](https://github.com/junegunn/fzf.vim)
- [scnvim](https://github.com/davidgranstrom/scnvim)
- Nvim >= v0.7

## Installation

### packer.nvim

```lua
use {
	'madskjeldgaard/fzf-sc',
	requires = {
		'vijaymarupudi/nvim-fzf',
		'davidgranstrom/scnvim'
	}
}
```


### vim-plug
For vim-plug users, add this to your init.vim:

`Plug 'madskjeldgaard/fzf-sc'`

Then run `:PlugInstall`.

## Setup

Load the extension **after** the call to `scnvim.setup`.

```lua
scnvim.setup{...}

scnvim.load_extension('fzf-sc')
```


### Configuration

fzf-sc may be configured by supplying a table to the setup function in a lua file:

```lua
require'fzf-sc'.setup({
	-- Set to "nvim-fzf" if you have that plugin installed
	search_plugin = "fzf.vim" 
})
```

## Available commands
`:SCNvimExt fzf-sc.fuzz`

Fuzzy search the fuzzy finders. Gets list of all fuzzy search commands. Choose one and execute it.

Invoking the commands directly works like this. An example using the `scales` finder:

```bash
:SCNvimExt fzf-sc.fuzz play_scales
```

## Make your own fuzzy finder

To make your own finder, you need two things: Some supercollider code that generates an array and a callback (can be either SuperCollider or Lua). The callback is a piece of code that takes the result of your choice and does something with it. 


### Defining a fuzzy finder in SuperCollider

This plugin comes with a SuperCollider class that makes it easy to define your own custom fuzzy finders. This allows you to add project based or setup specific finders that maybe aren't relevant for everyone but very relevant for you :)

```supercollider
FZFSC.new(
	// The name of your finder. You can invoke it in NeoVim by running the following command in nvim:
	// :SCNvimExt fzf-sc.fuzz numberlister
	// And additionally, it is available in the main list of finders:
	// :SCNvimExt fzf-sc.fuzz
	name: "numberlister", 

	// A piece of SuperCollider code that returns an array of some things that we can fuzzy find over
	itemsCode: "[1,5,2,4,3,9,666]",

	// A formatted string containing a piece of SuperCollider code. 
	// The %s bit will be replaced with the item you chose from the array above.
	callbackFunc: "\"%s\".postln"
)
```

### Defining a fuzzy finder in LUA

Here is an example of getting all quarks as input and then installing the chosen item in the return code. The return code is a string where `%s` is replaced with the result of the fuzzy search, eg in the example below it will be the name of the quark the user chooses.

By adding your finder to `finders.lua`, it will automatically show up when you run `:SCNvimExt fzf-sc.fuzz`.

```lua
local utils = require"scnvim._extensions.fzf-sc.utils"

require"scnvim._extensions.fzf-sc.finders".my_quark_installer = 
function()
	local sc_code = [[Quarks.fetchDirectory; Quarks.all.collect{|q| q.name}]];
	local supercollider_callback = [[Quarks.install("%s");]];

	utils.fzf_sc_eval(sc_code, supercollider_callback)
end
```

#### Using a lua callback

Instead of using SuperCollider in the callback, it is also possible to pass your choice from the fuzzy list to a lua function and make use of Neovim's lua api.

```lua
local utils = require"scnvim._extensions.fzf-sc.utils"

require"scnvim._extensions.fzf-sc.finders".my_quark_browser = 
function()

	-- Get a list of all quark folders in your system and convert them to full paths
	local sc_code = [[PathName(Quarks.folder).folders.collect{|folder| folder.fullPath}
]];

	-- This callback opens the chosen folder in a new tab
	local callback = function(val) 
		vim.cmd("tabnew " ..val) 
	end

	utils.fzf_sc_eval(sc_code, callback)
end
```

### More inspiration 

For more inspiration [see this file](lua/scnvim/_extensions/fzf-sc/finders.lua). 

## Contributing a finder

Finders are defined in [this file](lua/scnvim/_extensions/fzf-sc/finders.lua). 

If you feel like contributing a finder, that's where to do it.
