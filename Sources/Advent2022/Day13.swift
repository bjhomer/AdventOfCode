//
//  Day13.swift
//  
//
//  Created by BJ Homer on 12/13/22.
//

import Foundation
import AdventCore


struct Day13: Day {
    private var pairs: [SignalPair]

    init(input: URL) async throws {
        pairs = try String(contentsOf: input, encoding: .utf8)
            .split(separator: "\n\n")
            .compactMap { input -> SignalPair? in
                guard let (s1, s2) = input.split(separator: "\n")
                    .compactMap({ Signal(line: $0) })
                    .explode()
                else { return nil }

                return SignalPair(signal1: s1, signal2: s2)
            }
    }

    func part1() async {
        let result = pairs.indexed()
            .filter { (i, pair) in pair.isCorrectlyOrdered }
            .map { $0.0 + 1 }
            .reduce(0, +)
        print(result)
    }

    func part2() async {
        let dividers = [Signal(line: "[[2]]")!, Signal(line: "[[6]]")!]
        let allSignals = pairs.flatMap { [$0.signal1, $0.signal2] } + dividers
        let sortedSignals = allSignals.sorted()

        let index1 = sortedSignals.firstIndex(of: dividers[0])! + 1
        let index2 = sortedSignals.firstIndex(of: dividers[1])! + 1

        let result = index1 * index2
        print(result)

    }


}

private struct SignalPair: CustomStringConvertible {
    var signal1: Signal
    var signal2: Signal

    var isCorrectlyOrdered: Bool {
        return signal1 <= signal2
    }

    var description: String {
        "(\(signal1), \(signal2))"
    }
}

private enum Signal: Comparable {
    static func < (lhs: Signal, rhs: Signal) -> Bool {
        switch (lhs, rhs) {
        case (.int(let l), .int(let r)): return l < r
        case (.int(let l), .list): return Signal.list([.int(l)]) < rhs
        case (.list, .int(let r)): return lhs < Signal.list([.int(r)])
        case (.list(let l), .list(let r)):
            let result = l.lexicographicallyPrecedes(r)
            return result
        }
    }

    case int(Int)
    case list([Signal])

    init?<S>(line: S) where S: StringProtocol, S.SubSequence == Substring {
        var chars = line[...]
        self.init(chars: &chars)
    }

    private init?(chars: inout Substring) {

        if chars.first == "[" {
            chars.removeFirst()
            var signals: [Signal] = []
            innerLoop: while let signal = Signal(chars: &chars) {
                signals.append(signal)

                switch chars.popFirst()! {
                case "]": break innerLoop
                case ",": break
                default: fatalError()
                }
            }
            self = .list(signals)
        }
        else if chars.first?.isWholeNumber == true {
            var digits: String = ""
            while let char = chars.first,
                  char.isWholeNumber {
                digits.append(char)
                chars.removeFirst()
            }
            self = .int(Int(digits)!)
        }
        else {
            return nil
        }
    }
}

extension Signal: CustomStringConvertible {
    var description: String {
        switch self {
        case .int(let x): return String(x)
        case .list(let l): return "[\(l.map(\.description).joined(separator: ","))]"
        }
    }
}
