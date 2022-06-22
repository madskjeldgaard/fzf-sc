/*

SuperCollider interface for the NeoVim-plugin fzf-sc

Example usage:
FZFSC.new("johnnybobby", "(1..10)", "\"%s\".postln")

*/
FZFSC {
    var <finderName, callbackFunction;

    *new { | name, itemsCode, callbackFunc |
        ^super.new.init(name, itemsCode, callbackFunc)
    }

    init { | name, itemsCode, callbackFunc |
        this.registerFinder(name, itemsCode, callbackFunc);
    }

    prCallNeoVim{|call|
        // Wrap like this to avoid problems when not using SCNvim
        if(\SCNvim.asClass.notNil, {
            "Calling NeoVim's LUA api with the following lua code:".postln;
            \SCNvim.asClass.luaeval(call)
        });
    }

    // Retrieve the finder in lua code
    getFinder{|name|
        ^'require \"scnvim._extensions.fzfsc.finders\".' ++ name
    }

    // TODO allow lua callback
    registerFinder{|name, itemsCode, callbackFunc|
        var luacode;

        luacode = "print('adding fzf-sc finder %');"
        ++ "% = function() local sc_code = [[%]];"
        ++ "local supercollider_callback = [[%;]];"
        ++ "require'scnvim._extensions.fzfsc.utils'.fzf_sc_eval(sc_code, supercollider_callback);"
        ++ "end";

        luacode = luacode.format(
            name,
            this.getFinder(name),
            itemsCode,
            callbackFunc
        );

        this.prCallNeoVim(luacode.postln);
    }
}
