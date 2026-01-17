//
//  Day09.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/2025.
//

import Foundation
import AdventCore

struct Day09: AdventDay {
    
    var data: String
    var points: [GridPoint]
    
    init(data: String) {
        self.data = data
        self.points = data
            .lines
            .map { line in
                let (a, b) = line
                    .split(separator: ",")
                    .map { Int($0)! }
                    .explode()!
                return GridPoint(x: a, y: b)
            }
    }
    
    func part1() -> Int {
        let maxArea = points.combinations(ofCount: 2)
            .map { PossibleRect(a: $0[0], b: $0[1]) }
            .max(by: { $0.area < $1.area })!
        return maxArea.area
    }
    
    func part2() -> Int {
        return 0
    }
}

extension Day09 {
    struct PossibleRect {
        var a: GridPoint
        var b: GridPoint
        
        var area: Int {
            (abs(a.x - b.x) + 1) * (abs(a.y - b.y) + 1)
        }
    }
}

