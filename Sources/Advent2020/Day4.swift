//
//  Day4.swift
//  
//
//  Created by BJ Homer on 12/4/20.
//

import Foundation
import Algorithms
import AdventCore

func day4_2(input inputData: Data) {
    let input = String(decoding: inputData, as: UTF8.self)


    let dictionaries = input
        .split(separator: "\n", omittingEmptySubsequences: false)
        .chunked(by: { $1 != "" })
        .map {
            $0  .joined(separator: " ") // Join consecutive lines of the same passport
                .split(separator: " ")  // Split into passport fields
                .map { $0.split(separator: ":") } // Convert to key-value pair arrays
                .map { (String($0[0]), String($0[1])) } // Map each kvpair array into a tuple
        }
        .map { Dictionary(uniqueKeysWithValues: $0) }


    print(dictionaries)
}

func day4(input inputData: Data) {
    day4_2(input: inputData)

    let input = String(decoding: inputData, as: UTF8.self)

    let lines = input
        .split(separator: "\n", omittingEmptySubsequences: false)

    let fullPassportLines = lines
        .chunked(by: { String($1) != "" })
        .map { $0.joined(separator: " ") }

    let passports = fullPassportLines.map(Passport.init)

    let validCount = passports.filter({$0.isValidPart1}).count
    print("------")
    print("Part 1")
    print(validCount)

    print("")

    print("------")
    print("Part 2")
    let validPart2 = passports.filter({ $0.isValidPart2 }).count
    print(validPart2)
}


private struct Passport {
    var fields: [String: String]

    init(_ fields: String) {
        let kvPairs = fields
            .split(separator: " ")
            .compactMap {
                $0.split(separator: ":").asStringPair()
            }

        self.fields = Dictionary(uniqueKeysWithValues: kvPairs)
    }

    var byr: Int? { fields["byr"].flatMap(Int.init) }
    var iyr: Int? { fields["iyr"].flatMap(Int.init) }
    var eyr: Int? { fields["eyr"].flatMap(Int.init) }
    var hgt: Height? {
        let regex = ACRegex(#"^(\d+)(in|cm)$"#)

        guard let match = regex.match(fields["hgt"])
        else { return nil }
        let number = Int(match[1])!
        let unit = match[2]
        return Height(number, unit: unit)
    }
    var hcl: String? {
        let regex = ACRegex(#"^#([0-9a-f]{6})"#)
        guard let match = regex.match(fields["hcl"])
        else { return nil }
        return match[0]
    }
    var ecl: EyeColor? { fields["ecl"].flatMap(EyeColor.init(rawValue:)) }
    var pid: Int? {
        let regex = ACRegex(#"^\d{9}$"#)
        guard let matchString = regex.match(fields["pid"])?[0],
              let int = Int(matchString)
        else { return nil }
        return int
    }

    var isValidPart1: Bool {
        let expectedKeys: Set = [ "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
        return Set(fields.keys).intersection(expectedKeys) == expectedKeys
    }

    var isValidPart2: Bool {
        if let byr = self.byr, (1920...2002).contains(byr),
           let iyr = self.iyr, (2010...2020).contains(iyr),
           let eyr = self.eyr, (2020...2030).contains(eyr),
           let hgt = self.hgt, hgt.isValid,
           self.hcl != nil,
           self.ecl != nil,
           self.pid != nil
        {
            return true
        }
        return false

    }

    enum Height {
        case cm(Int)
        case `in`(Int)

        init?(_ count: Int, unit: String) {
            let value: Height
            switch unit {
            case "cm": value = .cm(count)
            case "in": value = .in(count)
            default: return nil
            }
            if value.isValid { self = value }
            else { return nil }
        }
        var isValid: Bool {
            switch self {
            case .cm(let x): return (150...193).contains(x)
            case .in(let x): return (59...76).contains(x)
            }
        }
    }

    enum EyeColor: String {
        case amb, blu, brn, gry, grn, hzl, oth
    }
}

private extension Array where Element: StringProtocol {
    func asStringPair() -> (String, String)? {
        guard self.count == 2 else { return nil }
        return (String(self[0]), String(self[1]))
    }
}

extension Collection {
    func pipe<T>(_ transform: (Self)->T) -> T {
        transform(self)
    }
}
