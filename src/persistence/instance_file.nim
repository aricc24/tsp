import strutils
import ../models/city

proc loadInstance*(path: string, cities: seq[City]): seq[City] =
    let content = readFile(path).strip()
    let values = content.split(",")

    result = newSeq[City](values.len)

    for i in 0 ..< values.len:
        let cityId = parseInt(values[i].strip())
        result[i] = cities[cityId - 1]