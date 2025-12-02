//
//  Day15.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/13/24.
//

import Foundation
import AdventCore


struct Day15: AdventDay {
    
    var warehouse: Warehouse
    var instructions: [Instruction]
    
    init(data: String) {
        let (gridChunk, instructions) = data.split(separator: "\n\n").explode()!
        warehouse = .init(gridChunk: gridChunk)
        
        self.instructions = instructions
            .replacing("\n", with: "")
            .compactMap { Instruction($0) }
    }
    
    func part1() async throws -> Int {
        var warehouse = self.warehouse
        for instruction in instructions {
            warehouse.execute(instruction: instruction)
        }
    
        return warehouse.score()
    }
    
    func part2() async throws -> Int {
        0
    }
}

extension Day15 {
    struct Warehouse {
        var grid: Grid<Character>
        var robotPosition: GridPoint
        
        init(gridChunk: Substring) {
            let gridLines = gridChunk.split(separator: "\n")
            grid = Grid(gridLines)
            
            robotPosition = grid.firstIndex(of: "@")!
        }
        
        mutating func execute(instruction: Instruction) {
            let values = grid
                .values(from: robotPosition, direction: instruction.direction, limit: nil)
            let valuesBeforeSpace = values.prefixThroughFirst(where: { $0 == "."})
            
            if valuesBeforeSpace.contains("#") {
                // Nothing we can push
                return
            }
            
            let positionsToUpdate = zip(
                grid.indices(from: robotPosition, direction: instruction.direction),
                ["."] + valuesBeforeSpace.dropLast()
            )
            for (point, value) in positionsToUpdate {
                grid[point] = value
            }
            
            robotPosition = grid.index(moved: instruction.direction, from: robotPosition)!
        }
        
        func score() -> Int {
            grid
                .indices
                .filter { grid[$0] == "O" }
                .map { (100 * $0.y) + $0.x }
                .reduce(0, +)
        }
    }
    
    struct Instruction {
        var direction: GridDirection
        
        init(_ dir: GridDirection) {
            direction = dir
        }
        
        init?(_ char: Character) {
            switch char {
            case "^": direction = .up
            case "v": direction = .down
            case ">": direction = .right
            case "<": direction = .left
            default: return nil
            }
        }
    }
}
