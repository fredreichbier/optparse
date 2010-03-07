import optparse/Parser

Option: abstract class {
    key: String

    storeValue: func <T> (parser: Parser, value: T) {
        parser values put(key, value)
    }

    storeDefault: abstract func (parser: Parser)
    activate: abstract func (parser: Parser, reader: CommandLineReader) -> Bool
}

SimpleOption: abstract class extends Option {
    longName, shortName: String

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

    activate2: abstract func (parser: Parser, reader: CommandLineReader)
}

ToggleOption: class extends SimpleOption {
    store, defaultValue: Bool

    init: func ~verbose (=key, =longName, =shortName, =store, =defaultValue) {
    
    }

    init: func ~storeTrue (=key, =longName, =shortName, =defaultValue) {
        store = true
    }

    activate2: func (parser: Parser, reader: CommandLineReader) {
        storeValue(parser, store)
    }

    storeDefault: func (parser: Parser) {
        storeValue(parser, defaultValue)
    }
}

StringOption: class extends SimpleOption {
    defaultValue: String

    init: func (=key, =longName, =shortName, =defaultValue) {
    
    }
    
    activate2: func (parser: Parser, reader: CommandLineReader) {
        storeValue(parser, reader get())
    }

    storeDefault: func (parser: Parser) {
        storeValue(parser, defaultValue)
    }
}
