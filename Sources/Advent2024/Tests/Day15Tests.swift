//
//  Day15Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/10/24.
//

import Testing
@testable import Advent2024
import AdventCore

@Suite("2024.15 Tests")
struct Day15Tests {
    @Test
    func testSample1() async throws {
        let grid = """
            ########
            #..O.O.#
            ##@.O..#
            #...O..#
            #.#.O..#
            #...O..#
            #......#
            ########
            """
        
        let expected = """
            ########
            #..O.O.#
            ##@.O..#
            #...O..#
            #.#.O..#
            #...O..#
            #......#
            ########
            """
        
        let output = test(start: grid, direction: .left)
        #expect(output == expected)
    }
    
    @Test
    func testSample2() async throws {
        let grid = """
            ########
            #..O.O.#
            ##@.O..#
            #...O..#
            #.#.O..#
            #...O..#
            #......#
            ########
            """
        
        let expected = """
            ########
            #.@O.O.#
            ##..O..#
            #...O..#
            #.#.O..#
            #...O..#
            #......#
            ########
            """
        
        let output = test(start: grid, direction: .up)
        #expect(output == expected)
    }
    
    @Test
    func testSample3() async throws {
        let grid = """
            ########
            #.@O.O.#
            ##..O..#
            #...O..#
            #.#.O..#
            #...O..#
            #......#
            ########
            """
        
        let expected = """
            ########
            #.@O.O.#
            ##..O..#
            #...O..#
            #.#.O..#
            #...O..#
            #......#
            ########
            """
        
        let output = test(start: grid, direction: .up)
        #expect(output == expected)
    }
    
    @Test
    func testSample4() async throws {
        let grid = """
            ########
            #.@O.O.#
            ##..O..#
            #...O..#
            #.#.O..#
            #...O..#
            #......#
            ########
            """
        
        let expected = """
            ########
            #..@OO.#
            ##..O..#
            #...O..#
            #.#.O..#
            #...O..#
            #......#
            ########
            """
        
        let output = test(start: grid, direction: .right)
        #expect(output == expected)
    }
    
    @Test
    func testSample5() async throws {
        let grid = """
            ########
            #..@OO.#
            ##..O..#
            #...O..#
            #.#.O..#
            #...O..#
            #......#
            ########
            """
        
        let expected = """
            ########
            #..@OO.#
            ##..O..#
            #...O..#
            #.#.O..#
            #...O..#
            #......#
            ########
            """
        
        let output = test(start: grid, direction: .right)
        #expect(output == expected)
    }
    
    
    
    @Test
    func testSample() async throws {
        let grid = """
            ########
            #..O.O.#
            ##@.O..#
            #...O..#
            #.#.O..#
            #...O..#
            #......#
            ########
            """
        
        let expected = """
            ########
            #....OO#
            ##.....#
            #.....O#
            #.#O@..#
            #...O..#
            #...O..#
            ########
            """
        
        var warehouse = Day15.Warehouse(gridChunk: grid[...])
        let instructions = "<^^>>>vv<v>>v<<".compactMap { Day15.Instruction($0) }
        for instruction in instructions {
            warehouse.execute(instruction: instruction)
        }
        let output = warehouse.grid.string
        
        #expect(output == expected)
    }
    
    @Test
    func testSampleLarge() async throws {
        let grid = """
            ##########
            #..O..O.O#
            #......O.#
            #.OO..O.O#
            #..O@..O.#
            #O#..O...#
            #O..O..O.#
            #.OO.O.OO#
            #....O...#
            ##########
            """
        
        let expected = """
            ##########
            #.O.O.OOO#
            #........#
            #OO......#
            #OO@.....#
            #O#.....O#
            #O.....OO#
            #O.....OO#
            #OO....OO#
            ##########
            """
        
        let instructions = """
            <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
            vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
            ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
            <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
            ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
            ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
            >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
            <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
            ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
            v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
            """.replacing("\n", with: "")
            .compactMap{ Day15.Instruction($0) }
        
        var warehouse = Day15.Warehouse(gridChunk: grid[...])
        
        for instruction in instructions {
            warehouse.execute(instruction: instruction)
        }
        let output = warehouse.grid.string
        
        #expect(output == expected)
    }

    
    func test(start: String, direction: GridDirection) -> String {
        var warehouse = Day15.Warehouse(gridChunk: start[...])
        warehouse.execute(instruction: .init(direction))
        let output = warehouse.grid.string
        return output
    }
    
}
