import structs/[ArrayList, HashBag]
import text/[StringTokenizer]

import optparse/Option

ParserError: class extends Exception {
    parser: Parser

    init: func ~withMsg (=parser, .message) {
        super(message)
    }

    print: func {
        "%s" printfln(message)
        parser displayHelp()
    }
}

/* transform ["--a=hello world"] to ["--a", "hello world"] */
transformArgs: func (args: ArrayList<String>) -> ArrayList<String> {
    result := ArrayList<String> new()
    for(arg in args) {
        if(arg contains?('=')) {
            // split!
            result addAll(arg split('=', 1))
        } else {
            result add(arg)
        }
    }
    result
}

CommandLineReader: class {
    args: ArrayList<String>
    index: SizeT
    parser: Parser

    init: func (=parser, =args) {
        index = 0
    }
    
    isValid: func -> Bool {
        index < args size
    }
    
    peek: func -> String {
        if(index >= args size) {
            parser error("I smell incompleteness.")    
        } else {
            return args[index]
        }
    }

    skip: func {
        index += 1
    }

    get: func -> String {
        index += 1
        if(index > args size) {
            parser error("I smell incompleteness.")    
        } else {
            return args[index - 1]
        }
    }
}

Parser: class {
    args: ArrayList<String>
    options: ArrayList<Option>
    values: HashBag
    positional: ArrayList<String>

    init: func {
        options = ArrayList<Option> new()
    }

    addOption: func (option: Option) {
        options add(option)
    }

    createHelp: func -> String {
        buf := Buffer new()
        for(option in options) {
            buf append(option createHelp())
        }
        buf toString()
    }

    displayHelp: func {
        createHelp() println()
    }

    error: func (msg: String) {
        ParserError new(this, msg) throw()
    }

    parse: func (args: ArrayList<String>) {
        // new positional args
        positional = ArrayList<String> new()
        // new values
        values = HashBag new()
        for(option in options)
            option storeDefault(this)
        // yay, parse
        reader := CommandLineReader new(this, transformArgs(args))
        // strip first arg (executable).
        executable := reader get()
        positionalFollow := false
        while(reader isValid() && !positionalFollow) {
            // no option matches. positional arguments.
            positionalFollow = true
            for(option in options) {
                if(option activate(this, reader)) {
                    // option matched. no positional arguments yet.
                    positionalFollow = false
                    break
                }
            }
        }
        while(positionalFollow && reader isValid()) {
            positional add(reader get())
        }
    }
}
