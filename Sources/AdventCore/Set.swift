//
//  File.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/7/24.
//

import Foundation

public extension Set {
    func intersects(_ other: Set<Element>) -> Bool {
        return isDisjoint(with: other) == false
    }
}
