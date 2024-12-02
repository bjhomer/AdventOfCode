//
//  File.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation
import AdventCore
import Algorithms



func day8(input: String) {
    let lines = input.split(separator: "\n")

    assert(parseString("\"\"") == "")
    assert(parseString(#""abc""#) == "abc" )
    assert(parseString(#""aaa\"aaa""#) == "aaa\"aaa")


    let part1 = lines.map({ $0.count - parseString($0).count }).reduce(0, +)
    print("Part 1:", part1)


    assert(encode("\"\"") == #""\"\"""#)
    assert(encode("\"abc\"") == #""\"abc\"""#)

    let part2 = lines.map({ encode($0).count - $0.count }).reduce(0, +)
    print("Part 2:", part2)

}

func parseString<Str>(_ code: Str) -> String
where Str: StringProtocol {

    var result: String = ""

    var idx = code.startIndex
    while idx != code.endIndex {
        switch code[idx] {
        case "\"": break
        case "\\":
            let (char, range) = parseEscape(code[idx...])
            idx = range.upperBound
            result.append(char)
            continue

        case let x:
            result.append(x)

        }
        code.formIndex(after: &idx)
    }
    return result
}

func parseEscape<Str>(_ code: Str) -> (Character, Range<Str.Index>)
where Str: StringProtocol
{
    var idx = code.startIndex
    assert(code[idx] == "\\")

    code.formIndex(after: &idx)
    switch code[idx] {
    case #"\"#:
        return ("\\", code.startIndex..<code.index(after: idx))
    case "\"":
        return ("\"", code.startIndex..<code.index(after: idx))
    case "x":
        code.formIndex(after: &idx)
        let numbers = code[idx...].prefix(2)
        let charNumber = Int(numbers, radix: 16)!
        let char = Character(UnicodeScalar(charNumber)!)
        return (char, code.startIndex..<numbers.endIndex)
    default:
        fatalError()
        
    }
}

func encode<Str>(_ string: Str) -> String where Str: StringProtocol {

    var result: String = ""
    for x in string {
        switch x {
        case "\"": result += #"\""#
        case "\\": result += #"\\"#
        default: result.append(x)
        }
    }
    return #""\#(result)""#

}
