import parseopt
import strutils
import random

type CliOptions = object
    databasePath: string
    instancePath: string


proc parseArguments(): CliOptions = 
    var parser = initOptParser()

    for kind, key, value in parser.getopt():
        case kind

        of cmdLongOption, cmdShortOption: 
            case key
            of "db", "d": 
                result.databasePath = value
            
            of "instance", "i": 
                result.instancePath = value
            
            else: 
                raise newException(ValueError, "Unknown flag" & key)

        of cmdArgument: 
            discard

        of cmdEnd: 
            discard

proc validateArguments(options: CliOptions) =
    if options.databasePath.len == 0:
        raise newException(
            ValueError,
            "Missing required option: --db"
        )

    if options.instancePath.len == 0:
        raise newException(
            ValueError,
            "Missing required option: --instance"
        )
