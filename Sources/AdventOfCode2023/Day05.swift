import Algorithms
import AdventCore
import Foundation

struct Day05: AdventDay {

    private var seeds: [Int]
    private var maps: [Map]

    init(data: String) {
        let sections = data.split(separator: "\n\n")

        let seedMatch = sections.first!.wholeMatch(of: /seeds: (.*)/)!
        seeds = seedMatch.1
            .split(separator: " ")
            .compactMap { Int($0) }

        maps = sections.dropFirst().compactMap { Map(section: $0) }
    }

    func mapThroughAll(_ value: Int) -> Int {
        var result = value
        for map in maps {
            result = map.value(for: result)
        }
        return result
    }

    func part1() -> Int {
        let paths = seeds.map { seed in maps.reductions(seed, { $1.value(for: $0) }) }
        for path in paths {
            print(path.map(String.init).joined(separator: " -> "))
        }
        return paths.compactMap(\.last).min()!
    }

    func part2() -> Int {

        var composedMap = maps.reduce { $0.composed(with: $1) }!
        print(composedMap.mappings)

        let seedPairs = seeds.chunks(ofCount: 2)
        let ranges = seedPairs.map { pair in
            let (start, length) = pair.explode()!
            return Range(start: start, length: length)
        }

        var min = Int.max
        for range in ranges {
            for value in range {
                let result = composedMap.value(for: value)
//                let result = mapThroughAll(value)
                print("mapping \(value)->\(result)")
                if result < min { min = result }
            }
        }
        return min
    }
}

extension Day05 {
    struct Map {
        var mappings: [MappedRange]

        init?(section: Substring) {
            var lines = section.lines
            mappings = lines.dropFirst().compactMap { MappedRange(line: $0) }
        }

        init() {
            mappings = []
        }

        func value(for source: Int) -> Int {
            if let value = mappings.firstNonNil({$0.destination(for: source)}) {
                return value
            }
            return source
        }

        func composed(with other: Map) -> Map {
            var result = self
            for mapping in other.mappings {
                result.compose(with: mapping)
            }
            return result
        }

        mutating func compose(with input: MappedRange) {
            var mappingsToInsert: [MappedRange] = []

            var remainingInputs = [input]

            for i in 0..<mappings.count {
                let mapping = mappings[i]

                for input in remainingInputs {
                    guard let overlapInDest = mapping.destRange.intersection(input.sourceRange)
                    else { continue }

                    let overlapInSource = overlapInDest.offset(by: -mapping.offset)
                    mappingsToInsert.append(.init(sourceRange: overlapInSource, offset: mapping.offset + input.offset))
                    remainingInputs = input.remainders(outside: overlapInDest)
                }
            }

            if remainingInputs.isEmpty == false {
                mappingsToInsert.append(contentsOf: remainingInputs)
            }

            mappings.insert(contentsOf: mappingsToInsert, at: 0)
        }
    }

    struct MappedRange: Hashable {
        var sourceStart: Int
        var length: Int
        var offset: Int

        var destStart: Int { sourceStart + offset }
        var sourceRange: Range<Int> {
            Range(start: sourceStart, length: length)
        }

        var destRange: Range<Int> {
            Range(start: destStart, length: length)
        }

        var sourceEnd: Int { sourceRange.upperBound }

        func remainders(outside input: Range<Int>) -> [MappedRange] {
            var results: [MappedRange] = []

            if sourceStart < input.lowerBound,
               let lowerRemainder = self.split(atSource: sourceStart).first
            {
                results.append(lowerRemainder)
            }
            if input.upperBound < sourceRange.upperBound,
               let upperRemainder = self.split(atSource: input.upperBound).last
            {
                results.append(upperRemainder)
            }
            return results
        }

        func split(atSource value: Int) -> [MappedRange] {
            guard sourceRange.contains(value) else { return [self] }

            var lower = self
            var upper = self

            lower.length = value - sourceStart
            upper.sourceStart = value
            upper.length = sourceRange.upperBound - value

            return [lower, upper]
        }

        func split(atDestination value: Int) -> [MappedRange] {
            guard destRange.contains(value) else { return [self] }
            return split(atSource: value - offset)
        }


        init?(line: Substring) {
            guard let (a, b, c) = line
                .split(separator: " ")
                .compactMap({ Int($0) })
                .explode()
            else { return nil }

            offset = a - b
            sourceStart = b
            length = c
        }

        init(sourceRange: Range<Int>, offset: Int) {
            sourceStart = sourceRange.lowerBound
            length = sourceRange.upperBound - sourceRange.lowerBound
            self.offset = offset
        }

        func destination(for value: Int) -> Int? {
            if value >= sourceStart && value < sourceStart + length {
                return value + offset
            }
            else {
                return nil
            }
        }
    }
}

extension Day05.MappedRange: CustomStringConvertible {
    var description: String {
        return "(\(sourceRange) + \(offset))"
    }
}
