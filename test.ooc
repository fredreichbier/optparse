import structs/[Array, ArrayList]
import optparse/[Option, Parser]

test: func (parser: Parser, args: ArrayList<String>) {
    parser parse(args)
    "Name: %s " format(parser values get("name", String)) println()
    "Quiet: %d " format(parser values get("quiet", Bool)) println()
    "Libs: %s" format(parser values get("libs", ArrayList<String>) join(", ")) println()
    "Positional: %s" format(parser positional join(' ')) println()
}

main: func (args: Array<String>) {
    parser := Parser new()

    quiet := ToggleOption new("quiet") .longName("quiet") .shortName("q")
    name := StringOption new("name") .longName("name") .shortName("n")
    libs := ListOption new("libs") .longName("lib") .shortName("l")

    parser addOption(quiet) .addOption(name) .addOption(libs)
   
    test(parser, args toArrayList())
}
