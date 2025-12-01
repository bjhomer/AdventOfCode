//
//  Day14.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/13/24.
//

import Foundation
import AdventCore


struct Day14: AdventDay {
    
    var robots: [Robot] = []
    var gridSize: (width: Int, height: Int)
    
    init(data: String) {
        self.init(data: data, width: 101, height: 103)
    }
    
    init(data: String, width: Int, height: Int) {
        gridSize = (width, height)
        robots = data.split(separator: "\n")
            .compactMap { Robot(line: $0) }
    }

    func quadrant(for point: GridPoint) -> Int? {
        let s = gridSize
        
        let x = point.x - ((s.width-1) / 2)
        let y = point.y - ((s.height-1) / 2)
        
        switch (x, y) {
        case (...(-1), ...(-1)): return 4
        case (1..., 1...): return 1
        case (...(-1), 1...): return 3
        case (1..., ...(-1)): return 2
        case (_, _): return nil
        }
    }
    
    func part1() -> Int {
        robots
            .map { $0.position(after: 100, gridSize: gridSize) }
            .grouped(by: { quadrant(for: $0) })
            .filter { $0.key != nil }
            .map { $0.value.count }
            .printed()
            .reduce(1, *)
    }
    
    func part2() -> Int {
        0
    }
}

extension Day14 {
    struct Robot {
        var position: GridPoint
        var velocity: GridPoint
        
        init?(line: Substring) {
            let r = /p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/
            guard let matches = try? r.wholeMatch(in: line) else {
                print("Unable to parse line: [\(line)]")
                return nil
            }
            let x1 = Int(matches.1)!
            let y1 = Int(matches.2)!
            let x2 = Int(matches.3)!
            let y2 = Int(matches.4)!
            
            position = .init(x: x1, y: y1)
            velocity = .init(x: x2, y: y2)
        }
        
        func position(after steps: Int, gridSize: (width: Int, height: Int)) -> GridPoint {
            let newPoint = position + (velocity.scaled(by: steps))
            let wrappedPoint = GridPoint(
                x: newPoint.x.positiveMod(gridSize.width),
                y: newPoint.y.positiveMod(gridSize.height))
            return wrappedPoint
        }
    }
}
