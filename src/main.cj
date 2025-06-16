package ocr_numbers

import std.collection.ArrayList

main(): Int64 {
    let inputs = ArrayList<String>(4)
    inputs.append("    _  _ ")
    inputs.append(" |  _| _|")
    inputs.append("  ||_  _|")
    inputs.append("         ")
    inputs.append(" _  _    ")
    inputs.append("|_||_   |")
    inputs.append("  | _|  |") // 9 无法识别，输出为 ？
    inputs.append("         ")
    inputs.append("    _  _ ")
    inputs.append("  | _| _|")
    inputs.append("  ||_  _|")
    inputs.append("         ")
    let ocr = OpticalCharacterReader()
    let result = ocr.parse(inputs)
    println(result)
    return 0
}

class OpticalCharacterReader {
    private let info: String = 
        " _     _  _     _  _  _  _  _ " + 
        "| |  | _| _||_||_ |_   ||_||_|" +
        "|_|  ||_  _|  | _||_|  ||_| _|" + 
        "                              "

    public func parse(data: ArrayList<String>): String {
        if (data.size % 4 != 0) {
            throw IllegalStateException("Number of input rows must be a positive multiple of 4")
        }

        if (data.get(0).getOrThrow().size % 3 != 0) {
            throw IllegalStateException("Number of input columns must be a positive multiple of 3")
        }

        let res = Array<StringBuilder>(data.size / 4, item: StringBuilder())
        for (row in 0..(data.size / 4)) {
            res[row] = StringBuilder()
            for (col in 0..(data.get(row).getOrThrow().size / 3)) {
                for (i in 0..10) {
                    var found = true
                    for (j in 0..4) {
                        var res = data.get(4 * row + j)?[(3 * col)..(3 * (col + 1))]
                        var desc = info[(3 * (10 * j + i))..(3 * (10 * j + i + 1))]
                        if (res != desc) {
                            found = false
                            break
                        }
                    }
                    if (found) {
                        res[row].append(i)
                        break
                    }
                    if (i == 9) {
                        res[row].append('?')
                    }
                }
            }
        }

        var r = ""
        for (i in 0..res.size) {
            if (i == res.size - 1) {
                r = r + res[i].toString()
                break
            }
            r = r + res[i].toString() + ","
        }
        return r
    }
}
