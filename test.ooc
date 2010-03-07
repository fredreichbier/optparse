import structs/ArrayList
import optparse/[Option, Parser]

test: func (parser: Parser, args: ArrayList<String>) {
    parser parse(args)
    "Quiet? %d " format(parser values get("quiet", Bool)) println()
    "Positional: %s" format(parser positional join(' ')) println()
}

main: func {
    parser := Parser new()
    parser addOption(ToggleOption new("quiet", "quiet", "q", false))
    test(parser, ["-q"] as ArrayList<String>)
    test(parser, ["--quiet", "blablubb"] as ArrayList<String>)
    test(parser, ["rhabarber"] as ArrayList<String>)
    test(parser, ["--schmurx"] as ArrayList<String>)
}
