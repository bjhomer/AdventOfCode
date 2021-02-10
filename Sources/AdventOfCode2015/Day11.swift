//
//  File.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation
import AdventCore
import Algorithms


func day11(input: String) {
    let password = Password(input)
    let part1 = password.nextPassword()
    print("Part 1: \(part1)")

    let part2 = part1.nextPassword()
    print("Part 2: \(part2)")

}

private struct Password {
    var string: String

    init(_ string: String) {
        self.string = string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }

    func nextPassword() -> Password {
        var password = self
        repeat {
            password.increment()
        } while !(password.isValid)
        return password
    }

    var isValid: Bool {
        return hasIncreasingSequence
        && !(hasInvalidCharacters)
        && hasTwoRepeatingPairs
    }

    var hasIncreasingSequence: Bool {
        let chunks = string.chunked { (a, b) in
            a.asciiValue! == b.asciiValue! - 1
        }
        return chunks.contains(where: { $0.count >= 3 })
    }

    var hasInvalidCharacters: Bool {
        return string.contains(where: { ["l", "o", "i"].contains($0) })
    }

    var hasTwoRepeatingPairs: Bool {
        let pairs = string
            .chunked(on: { $0 })
            .filter { $0.count >= 2 }

        let uniqueLetters = Set(pairs.compactMap(\.first))

        return pairs.count >= 2 && uniqueLetters.count >= 2
    }

    mutating func increment() {
        let alphabet = Array("abcdefghijklmnopqrstuvwxyza")
        var letters = Array(string)

        for i in (0..<letters.count).reversed() {
            let letterNumber = alphabet.firstIndex(of: letters[i])!
            let newLetter = alphabet[letterNumber+1]
            letters[i] = newLetter

            if newLetter != "a" { break }
        }
        string = String(letters)
    }
}

extension Password: CustomStringConvertible {
    var description: String { return string }
}

