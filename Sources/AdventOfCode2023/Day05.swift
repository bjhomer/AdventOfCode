import Algorithms
import SE0270_RangeSet
import AdventCore
import Foundation

struct Day05: AdventDay {

    var seeds: [Int]
    var maps: [Map]

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
//        for path in paths {
//            print(path.map(String.init).joined(separator: " -> "))
//        }
        return paths.compactMap(\.last).min()!
    }

    func part2() -> Int {

        let composedMap = maps.reduce { $0.composed(with: $1) }!

        let seedPairs = seeds.chunks(ofCount: 2)
        let seedRanges = seedPairs.map { pair in
            let (start, length) = pair.explode()!
            return Range(start: start, length: length)
        }

//        print(composedMap)

        let mappedRanges = composedMap.mappedRanges.sorted(on: \.destStart)

        let result = mappedRanges
            .firstNonNil { (mappedRange) in
                seedRanges
                    .compactMap { $0.intersection(mappedRange.sourceRange) }
                    .sorted(on: \.lowerBound)
                    .first
            }!

        let path = maps.reductions(result.lowerBound, { $1.value(for: $0) })
        print(path.map(String.init).joined(separator: " -> "))
        print(composedMap.offset(for: result.lowerBound))
        return composedMap.value(for: result.lowerBound)

//        for range in mappedRanges {
//            seedRanges.first(where: { range.overlaps })
//        }
    }
}

extension Day05 {
    struct Map: CustomStringConvertible {
        var rangeOffsets: RangeDict<Int>

        var mappedRanges: [MappedRange] {
            rangeOffsets.ranges
                .map { MappedRange(sourceRange: $0, offset: rangeOffsets[$0.lowerBound] ?? 0)
                }
        }

        init?(section: Substring) {
            let lines = section.lines
            let ranges = lines.dropFirst()
                .compactMap { MappedRange(line: $0) }
                .sorted(on: \.sourceStart)

            rangeOffsets = .init()

            for mappedRange in ranges {
                rangeOffsets.setRange(mappedRange.sourceRange, to: mappedRange.offset)
            }
        }

        init() {
            rangeOffsets = .init()
        }

        func offset(for source: Int) -> Int {
            return rangeOffsets[source] ?? 0
        }

        func value(for source: Int) -> Int {
            if let offset = rangeOffsets[source] {
                return source + offset
            }
            return source
        }

        mutating func insert(_ range: MappedRange) {
            rangeOffsets.setRange(range.sourceRange, to: range.offset)
        }

        func composed(with other: Map) -> Map {
            var result = self

            let rangesToApply = other.mappedRanges.flatMap { mappedRanges(forApplying:$0) }

            for range in rangesToApply {
                result.insert(range)
            }
//            print("Composed Map:")
//            print(result)
//            print("")
            return result
        }

        func mappedRanges(forApplying input: MappedRange) -> [MappedRange] {

            var remainder = RangeSet(input.sourceRange)
            var results: [MappedRange] = []

            for range in mappedRanges {
                let rangeOffset = range.offset

                let inputRangeInSource = input.sourceRange.offset(by: -rangeOffset)
                if let overlap = range.sourceRange.intersection(inputRangeInSource) {
                    results.append(.init(sourceRange: overlap, offset: range.offset + input.offset))
                    remainder.remove(contentsOf: overlap.offset(by: rangeOffset))
                }
            }
            for range in remainder.ranges {
                results.append(.init(sourceRange: range, offset: input.offset))
            }
            return results
        }

        var description: String {
            mappedRanges
                .sorted(on: \.destStart)
                .map(\.description)
                .joined(separator: "\n")
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
        return "\(sourceRange.description.padding(toLength: 30, withPad: " ", startingAt: 0)) \(destStart)"
    }
}
