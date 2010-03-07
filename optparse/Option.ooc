import structs/ArrayList

import optparse/Parser

Option: abstract class {
    key: String

    init: func (=key) {}

    storeValue: func <T> (parser: Parser, value: T) {
        parser values put(key, value)
    }
    
    storeDefault: abstract func (parser: Parser)
    activate: abstract func (parser: Parser, reader: CommandLineReader) -> Bool
}

SimpleOption: abstract class extends Option {
    longName := ""
    shortName := ""

    activate: func (parser: Parser, reader: CommandLineReader) -> Bool {
        token := reader peek()
        longNameTemplate := "--" + longName
        shortNameTemplate := "-" + shortName
        if((!longName isEmpty() && token equals(longNameTemplate)) \
            || (!shortName isEmpty() && token equals(shortNameTemplate))) {
            reader skip()
            activate2(parser, reader)
            return true
        }
        return false
    }

    longName: func (=longName) {}
    shortName: func (=shortName) {}

    activate2: abstract func (parser: Parser, reader: CommandLineReader)
}

ToggleOption: class extends SimpleOption {
    store := true
    defaultValue := false

    init: func ~doggl (=key) {}

    activate2: func (parser: Parser, reader: CommandLineReader) {
        storeValue(parser, store)
    }

    storeDefault: func (parser: Parser) {
        storeValue(parser, defaultValue)
    }

    store: func (=store) {}
    defaultValue: func (=defaultValue) {}
}

StringOption: class extends SimpleOption {
    defaultValue := ""

    init: func ~s (=key) {}

    activate2: func (parser: Parser, reader: CommandLineReader) {
        storeValue(parser, reader get())
    }

    storeDefault: func (parser: Parser) {
        storeValue(parser, defaultValue)
    }

    defaultValue: func (=defaultValue) {}
}

ListOption: class extends SimpleOption {
    init: func ~ichLiebeWurstsalat (=key) {}

    activate2: func (parser: Parser, reader: CommandLineReader) {
        parser values get(key, ArrayList<String>) add(reader get())
    }

    storeDefault: func (parser: Parser) {
        storeValue(parser, ArrayList<String> new())
    }
}
