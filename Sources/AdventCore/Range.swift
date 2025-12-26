//
//  Range.swift
//  
//
//  Created by BJ Homer on 12/13/23.
//

import Foundation

extension Range where Bound == Int {
    public init(start: Int, length: Int) {
        self = start..<(start+length)
    }
}

extension Range where Bound: Comparable {
    public func contains(_ value: Bound) -> Bool {
        return value >= lowerBound && value < upperBound
    }

    public func intersection(_ other: Self) -> Self? {
        guard self.overlaps(other) else { return nil }

        let lower = Swift.max(lowerBound, other.lowerBound)
        let upper = Swift.min(upperBound, other.upperBound)

        return lower..<upper
    }
}

extension Range where Bound: AdditiveArithmetic {
    public func offset(by value: Bound) -> Self {
        return (lowerBound+value)..<(upperBound+value)
    }
}
