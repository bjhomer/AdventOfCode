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

        maps = sections.dropFirst()
            .compactMap { Map(section: $0) }
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
    struct Map: CustomStringConvertible {
        var mappings: [MappedRange]

        init?(section: Substring) {
            let lines = section.lines
            mappings = lines.dropFirst()
                .compactMap { MappedRange(line: $0) }
                .sorted(on: \.sourceStart)
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
            var remainingInput = input
            var newMappings = self.mappings.sorted(on: \.destStart)

            var foundStart = false
            var foundEnd = false
            for mapping in newMappings {
                let overlap = mapping.destRange.intersection(remainingInput.sourceRange)

                if !foundStart {
                    if remainingInput.sourceStart < mapping.destStart {
                        // The input starts before this mapping. Just insert that portion.
                        let prefixInput = MappedRange(sourceRange: remainingInput.sourceStart..<mapping.destStart,
                                                      offset: remainingInput.offset)
                        newMappings.append(prefixInput)
                        remainingInput.discardBefore(source: mapping.destStart)
                        foundStart = true
                    }
                    else if remainingInput.sourceStart < mapping.sourceEnd {
                        // the input starts _within_ this mapping. Split this mapping in half
//                        let prefix = mapping.discardAfter(dest: remainingInput.sourceStart)
                        foundStart = true
                    }
                }

            }
        }

        mutating func compose2(with input: MappedRange) {
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

        var description: String {
            mappings.map(\.description).joined(separator: "\n")
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
        var destEnd: Int { destRange.upperBound }

        func remainders(outside input: Range<Int>) -> [MappedRange] {
            var results: [MappedRange] = []

            if sourceStart < input.lowerBound,
               let lowerRemainder = self.split(atSource: sourceStart).before
            {
                results.append(lowerRemainder)
            }
            if input.upperBound < sourceRange.upperBound,
               let upperRemainder = self.split(atSource: input.upperBound).after
            {
                results.append(upperRemainder)
            }
            return results
        }

        mutating func discardBefore(source value: Int) {
            let clampedValue = value.clamped(to: sourceStart...sourceEnd)

            let delta = clampedValue - sourceStart
            sourceStart += delta
            length -= delta
        }

        mutating func discardBefore(dest value: Int) {
            let clampedValue = value.clamped(to: destStart...destEnd)

            let delta = clampedValue - destStart
            sourceStart += delta
            length -= delta
        }

        mutating func discardAfter(source value: Int) {
            let clampedValue = value.clamped(to: sourceStart...sourceEnd)

            let delta = sourceEnd - clampedValue
            length -= delta
        }

        mutating func discardAfter(dest value: Int) {
            let clampedValue = value.clamped(to: destStart...destEnd)

            let delta = destEnd - clampedValue
            length -= delta
        }



        func split(atSource value: Int) -> (before: MappedRange?, after: MappedRange?) {
            guard sourceRange.contains(value) else {
                if sourceRange.upperBound <= value { return (self, nil) }
                else { return (nil, self) }
            }

            var lower = self
            var upper = self

            lower.length = value - sourceStart
            upper.sourceStart = value
            upper.length = sourceRange.upperBound - value

            return (lower, upper)
        }

        func split(atDestination value: Int) -> (before: MappedRange?, after: MappedRange?) {
            guard destRange.contains(value) else {
                if destRange.upperBound <= value { return (self, nil) }
                else { return (nil, self) }
            }
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
