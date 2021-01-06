//
//  File.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation

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
}

public extension String {
    func split<Str>(separator: Str) -> [SubSequence]
    where Str: StringProtocol
    {
        if separator.count == 1 {
            return split(separator: separator.first!)
        }
        else {
            return self.splitImpl(separator: separator)
        }
    }
}

public extension Collection where Element: Equatable {
    func split<C>(separator: C) -> [Self.SubSequence]
    where C: Collection, C.Element == Element
    {
        return splitImpl(separator: separator)
    }

    fileprivate func splitImpl<C>(separator: C) -> [Self.SubSequence]
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
}

