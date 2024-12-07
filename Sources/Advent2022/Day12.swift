//
//  Day12.swift
//  
//
//  Created by BJ Homer on 12/10/22.
//

import Foundation
import AdventCore
import Collections

struct Day12: Day {
    private var grid: Grid<Character>

    init(input: URL) async throws {
        grid = try Grid(input.allLines.filter { $0.isEmpty == false })
    }

    func part1() async {

        let start = grid.firstIndex(of: "S")!
        let end = grid.firstIndex(of: "E")!

        let path = grid.breadthFirstSearch(from: start, to: end) { a, b in
            grid[a].canTravel(to: grid[b])
        }

        if let path {
            print(path.count - 1)
        }
        else {
            print("no path")
        }
    }

    func part2() async {

        let start = grid.firstIndex(of: "E")!

        let path = grid.breadthFirstSearch(from: start, goalTest: { grid[$0].canonicalized() == "a" }) { a, b in
            grid[a].canTravel(from: grid[b])
        }

        if let path {
            print(path.count - 1)
        }
        else {
            print("no path")
        }
    }
}

private extension Character {
    func canTravel(to other: Character) -> Bool {
        return Int(other.canonicalized().asciiValue!) - Int(self.canonicalized().asciiValue!) <= 1
    }

    func canTravel(from other: Character) -> Bool {
        return other.canTravel(to: self)
    }

    func canonicalized() -> Self {
        if self == "S" { return "a" }
        if self == "E" { return "z" }
        return self
    }
}



private extension Grid where T: Equatable {

    private class PathNode {
        var item: Index
        var previous: PathNode?
        init(item: Index, previous: PathNode?) {
            self.item = item
            self.previous = previous
        }

        func path() -> [Index] {
            var items: [Index] = []
            var current: PathNode? = self
            while let x = current {
                items.append(x.item)
                current = x.previous
            }
            return items.reversed()
        }
    }

    func breadthFirstSearch(from: Index, to: Index, canTraverse: (Index, Index)->Bool) -> [Index]? {
        return breadthFirstSearch(from: from, goalTest: {$0 == to}, canTraverse: canTraverse)
    }

    func breadthFirstSearch(from: Index, goalTest: (Index)->Bool, canTraverse: (Index, Index)->Bool) -> [Index]? {
        var searchList = Deque([PathNode(item: from, previous: nil)])
        var visited: Set<Index> = [from]

        while let node = searchList.popFirst() {
            if goalTest(node.item) {
                return node.path()
            }

            let candidates = self.cardinalNeighbors(of: node.item)
                .filter { canTraverse(node.item, $0) && visited.contains($0) == false }
                .map { PathNode(item: $0, previous: node) }

            visited.formUnion(candidates.map(\.item))
            searchList.append(contentsOf: candidates)
        }

        return nil

    }
}
