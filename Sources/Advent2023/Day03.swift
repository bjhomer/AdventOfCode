import Algorithms
import AdventCore

struct Day03: AdventDay {

    var grid: Grid<Character>

    init(data: String) {
        grid = Grid(data.lines)
    }


    func part1() -> Int {
        let symbolLocations = grid
            .indices
            .filter { grid[$0].isGridSymbol }


        let candidatePartLocations = symbolLocations
            .flatMap { grid.surroundingNeighbors(of: $0) }
        |> { Set($0) }


        let partNumbers = candidatePartLocations
            .compactMap { grid.partNumber(at:$0) }
            .uniqued(on: \.start)
            .map(\.value)

        return partNumbers.reduce(0, +)
    }

    func part2() -> Int {
        let starLocations = grid
            .indices
            .filter { grid[$0] == "*" }

        let gearLocations = starLocations
            .filter { grid.isGear(at: $0) }

        let gearValues = gearLocations
            .map { grid
                .surroundingPartNumbers(at: $0)
                .map(\.value)
                .reduce(1, *)
            }
        return gearValues.reduce(0, +)
    }
}


private extension Grid where T == Character {
    func partNumber(at index: Index) -> (start: Index, value: Int)? {
        func test(i: Index) -> Bool { self[i].isWholeNumber }
        guard let start = lastIndex(from: index, direction: .left, satisfying: test(i:) ),
              let end = lastIndex(from: index, direction: .right, satisfying: test(i:) )
        else { return nil }

        let chars = self[row: index.r][(start.c)...(end.c)]
        let result = Int(chars.joined())!
        return (start, result)
    }

    func surroundingPartNumbers(at index: Index) -> [(start: Index, value: Int)] {
        return surroundingNeighbors(of: index)
            .compactMap { partNumber(at: $0) }
            .uniqued(on: \.start)
    }

    func isGear(at index: Index) -> Bool {
        surroundingNeighbors(of: index)
            .compactMap { partNumber(at: $0) }
            .uniqued(on: \.start)
            .count == 2
    }
}

private extension Character {
    var isGridSymbol: Bool {
        return !isWholeNumber && self != "."
    }
}
