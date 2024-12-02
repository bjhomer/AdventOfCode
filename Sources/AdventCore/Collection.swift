//
//  Collection.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation
import AsyncAlgorithms

public extension Collection {

    func explode() -> (Element, Element)? {
        let tupleCount = 2
        guard self.count == tupleCount else { return nil }
        let items = self.prefix(tupleCount)
        var itr = items.makeIterator()
        guard let a = itr.next(),
              let b = itr.next()
        else { fatalError() }
        return (a, b)
    }

    func explode() -> (Element, Element, Element)? {
        let tupleCount = 3
        guard self.count == tupleCount else { return nil }
        let items = self.prefix(tupleCount)
        var itr = items.makeIterator()
        guard let a = itr.next(),
              let b = itr.next(),
              let c = itr.next()
        else { fatalError() }
        return (a, b, c)
    }

    func explode() -> (Element, Element, Element, Element)? {
        let tupleCount = 4
        guard self.count == tupleCount else { return nil }
        let items = self.prefix(tupleCount)
        var itr = items.makeIterator()
        guard let a = itr.next(),
              let b = itr.next(),
              let c = itr.next(),
              let d = itr.next()
        else { fatalError() }
        return (a, b, c, d)
    }

    func explode() -> (Element, Element, Element, Element, Element)? {
        let tupleCount = 5
        guard self.count == tupleCount else { return nil }
        let items = self.prefix(tupleCount)
        var itr = items.makeIterator()
        guard let a = itr.next(),
              let b = itr.next(),
              let c = itr.next(),
              let d = itr.next(),
              let e = itr.next()
        else { fatalError() }
        return (a, b, c, d, e)
    }

    func explode() -> (Element, Element, Element, Element, Element, Element)? {
        let tupleCount = 6
        guard self.count == tupleCount else { return nil }
        let items = self.prefix(tupleCount)
        var itr = items.makeIterator()
        guard let a = itr.next(),
              let b = itr.next(),
              let c = itr.next(),
              let d = itr.next(),
              let e = itr.next(),
              let f = itr.next()
        else { fatalError() }
        return (a, b, c, d, e, f)
    }


    var fullRange: Range<Index> { startIndex..<endIndex }

    func keyed<T>(by keyFunc: (Element)->T) -> [T: Element]
    where T: Hashable
    {
        var dict: [T: Element] = [:]
        for x in self {
            dict[keyFunc(x)] = x
        }
        return dict
    }

    func reduce(_ step: (Element, Element)->Element) -> Element? {
        guard let initial = self.first else { return nil }
        let remainder = self.dropFirst()

        return remainder.reduce(initial, step)
    }

    func combinationsWithReplacement(count: Int) -> [[Element]] {
        if count == 0 { return [[]] }

        return self.flatMap { (head) in
            combinationsWithReplacement(count: count - 1)
                .map { [head] + $0 }
        }
    }
    
    func divided(at index: Index) -> (head: SubSequence, tail: SubSequence) {
        return (self[..<index], self[index...])
    }

    func divided(around index: Index) -> (head: SubSequence, tail: SubSequence) {
        let after = self.index(after: index)
        return (self[..<index], self[after...])
    }
    
    func offset(of index: Index) -> Int {
        distance(from: startIndex, to: index)
    }

    func printed() -> Self {
        Swift.print(self)
        return self
    }

    func prefixThroughFirst(where predicate: (Element) -> Bool) -> SubSequence {
        if let index = firstIndex(where: predicate) {
            return prefix(through: index)
        }
        else {
            return prefix(self.count)
        }
    }
}

public extension Collection where Self == SubSequence {
    mutating func popFirst() -> Element? {
        if isEmpty { return nil }
        return removeFirst()
    }
}

public extension RangeReplaceableCollection {

    @discardableResult
    mutating func popFirst() -> Element? {
        if isEmpty { return nil }
        let index = self.startIndex

        let item = self[index]
        remove(at: index)
        return item
    }
}

public extension Collection where Element: Equatable {
    func split<C>(separator: C) -> [Self.SubSequence]
    where C: Collection, C.Element == Element
    {
        return splitImpl(separator: separator)
    }

    internal func splitImpl<C>(separator: C) -> [Self.SubSequence]
    where C: Collection, C.Element == Element
    {
        guard let firstNeedle = separator.first else { return [self[...]] }

        let needleLength = separator.count
        var results: [Self.SubSequence] = []

        var startMatch = self.startIndex
        var startSearch = self.startIndex

        while let index = self[startSearch...].firstIndex(of: firstNeedle) {
            let possibleMatch = self[index...].prefix(needleLength)
            if separator.elementsEqual(possibleMatch) {
                results.append(self[startMatch..<index])
                startSearch = possibleMatch.endIndex
                startMatch = possibleMatch.endIndex
            }
            else {
                startSearch = self.index(after: startSearch)
            }
        }
        results.append(self[startMatch...])
        return results
    }

    func suffix(afterFirst separator: some Collection<Element>) -> SubSequence {
        guard let startIndex = self.split(separator: separator).dropFirst().first?.startIndex
        else { return self[endIndex..<endIndex] }

        return self[startIndex...]
    }
}

public extension Collection where Element: Hashable {
    var allUnique: Bool {
        return Set(self).count == self.count
    }
}

public extension Collection where Element: Comparable {
    var isSortedAscending: Bool {
        adjacentPairs().allSatisfy({ $0.0 < $0.1})
    }

    var isSortedDescending: Bool {
        adjacentPairs().allSatisfy({ $0.0 > $0.1})
    }
}

extension Sequence {
    public func sorted<T: Comparable>(on block: (Element)->T) -> [Element] {
        return self.sorted(by: { block($0) < block($1) })
    }
}

extension Sequence {
    public func collect() -> [Element] {
        return Array(self)
    }
}

extension AsyncSequence {
    public func collect() async rethrows -> [Element] {
        var result: [Element] = []
        for try await x in self {
            result.append(x)
        }
        return result
    }

    public func print() async throws -> AsyncLazySequence<[Element]> {
        let items = try await self.collect()
        Swift.print(items)
        return items.async
    }
}

extension AsyncSequence where Element: Equatable, Element: Sendable {
    public func split(separator: Element, isolation: isolated (any Actor) = #isolation) async -> AsyncThrowingStream<[Element], Error> {
        let iteratorBox = SendableBox(self.makeAsyncIterator())

        return AsyncThrowingStream {
            var items: [Element] = []

            var iterator = iteratorBox.value
            while let item = try await iterator.next() {
                if item == separator {
                    return items
                }
                else {
                    items.append(item)
                }
            }
            if items.count > 0 {
                return items
            }
            else {
                return nil
            }
        }
    }
}
