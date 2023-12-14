//
//  RangeDict.swift
//
//
//  Created by BJ Homer on 12/14/23.
//

import Foundation
import Algorithms
import Collections

/// Implements a dictionary where values can be applied to a range
/// of values efficiently
public struct RangeDict<Value> {
    private var keys: [Int] = []
    private var storage: [Int: Value?] = [:]

    public init() {}

    public func value(at index: Int) -> Value? {
        guard let key = keys.last(where: { $0 <= index })
        else { return nil }

        return storage[key] ?? nil
    }

    public mutating func updateRange(_ range: Range<Int>, transform: (inout Value?)->Void) {
        let currentEndValue = value(at: range.upperBound)

        let startIndex: Int

        if let insertionIndex = keys.firstIndex(of: range.lowerBound) {
            startIndex = insertionIndex
        }
        else {
            startIndex = keys.firstIndex(where: { range.lowerBound < $0 }) ?? keys.count
            keys.insert(range.lowerBound, at: startIndex)
        }

        let endIndex: Int
        if let existingEnd = keys.firstIndex(of: range.upperBound) {
            endIndex = existingEnd
        }
        else {
            endIndex = keys.firstIndex(where: { range.upperBound < $0 }) ?? keys.count
            keys.insert(range.upperBound, at: endIndex)
        }

        for idx in startIndex..<endIndex {
            let key = keys[idx]
            transform(&storage[key, default: nil])
        }
        let endKey = keys[endIndex]
        if storage.keys.contains(endKey) == false {
            storage[endKey] = .some(currentEndValue)
        }
    }

    public mutating func setRange(_ range: Range<Int>, to value: Value) {
        updateRange(range) { $0 = value }
    }

    public mutating func clearRange(_ range: Range<Int>) {
        updateRange(range) { $0 = nil }
    }

    public subscript(_ index: Int) -> Value? {
        value(at: index)
    }
}
