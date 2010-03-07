import structs/[ArrayList, HashBag]
import text/StringTokenizer
import optparse/Option

ParserError: class extends Exception {
    init: func ~withMsg (.msg) {
        super(msg)
    }
}

/* transform ["--a=hello world"] to ["--a", "hello world"] */
transformArgs: func (args: ArrayList<String>) -> ArrayList<String> {
    result := ArrayList<String> new()
    for(arg in args) {
        if(arg contains('=')) {
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

    init: func (=args) {
        index = 0
    }
    
    isValid: func -> Bool {
        index < args size()
    }
    
    peek: func -> String {
        args[index]
    }

    skip: func {
        index += 1
    }

    get: func -> String {
        index += 1
        args[index - 1]
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

    parse: func (args: ArrayList<String>) {
        // new positional args
        positional = ArrayList<String> new()
        // new values
        values = HashBag new()
        for(option in options)
            option storeDefault(this)
        // yay, parse
        reader := CommandLineReader new(transformArgs(args))
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
