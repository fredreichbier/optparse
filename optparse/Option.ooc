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
        if((!longName isEmpty() && token equals("--" + longName)) \
            || (!shortName isEmpty() && token equals("-" + shortName))) {
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
