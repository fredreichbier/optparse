import structs/[ArrayList, HashBag]

import optparse/Option

ParserError: class extends Exception {
    init: func ~withMsg (.msg) {
        super(msg)
    }
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
        reader := CommandLineReader new(args)
        positionalFollow := false
        while(reader isValid() && !positionalFollow) {
            for(option in options) {
                if(option activate(this, reader))
                    break
            }
            // no option matches. positional arguments.
            positionalFollow = true
        }
        while(positionalFollow && reader isValid()) {
            positional add(reader get())
        }
    }
}
