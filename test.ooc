import structs/ArrayList
import optparse/[Option, Parser]

test: func (parser: Parser, args: ArrayList<String>) {
    "ARGS: %s" format(args join(' ')) println()
    parser parse(args)
    "Name: %s " format(parser values get("name", String)) println()
    "Quiet: %d " format(parser values get("quiet", Bool)) println()
    "Positional: %s" format(parser positional join(' ')) println()
}

main: func {
    parser := Parser new()
    parser addOption(ToggleOption new("quiet", "quiet", "q", false))
    parser addOption(StringOption new("name", "name", "n", "Bla-Bli-Blubb"))
   
    test(parser, ["--quiet", "--name", "Wurst"] as ArrayList<String>)
    test(parser, ["--quiet", "-n=Wurst"] as ArrayList<String>)
    test(parser, ["--quiet", "--name=Hans Wurst", "one", "two", "three"] as ArrayList<String>)
}
