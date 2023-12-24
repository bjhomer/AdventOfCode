import Algorithms
import SE0270_RangeSet
import AdventCore
import Foundation
import Collections

struct Day08: AdventDay {

    var instructions: String
    var nodes: [String: Node]

    init(data: String) {
        var lines = data.lines
        instructions =  lines.popFirst()!.string

        let nodes = lines.compactMap { Node(line: $0) }
        self.nodes = nodes.keyed(by: \.name)
    }

    func part1() -> Int {
        var current = nodes["AAA"]!

        var stepCount = 0
        for step in instructions.cycled() {
            if current.name == "ZZZ" { break }
            switch step {
            case "L": current = nodes[current.left]!
            case "R": current = nodes[current.right]!
            default: fatalError()
            }
            stepCount += 1
        }
        return stepCount
    }

    func part2() -> Int {
        var currentNodes = nodes.keys
            .filter { $0.hasSuffix("A") }
            .map { nodes[$0]! }

        var stepCount = 0
        for step in instructions.cycled() {
            if currentNodes.allSatisfy({ $0.name.hasSuffix("Z") }) { break }
            switch step {
            case "L": 
                currentNodes = currentNodes.map { nodes[$0.left]! }
            case "R":
                currentNodes = currentNodes.map { nodes[$0.right]! }
            default: fatalError()
            }
            stepCount += 1
        }
        return stepCount

    }
}


extension Day08 {
    struct Node {
        var name: String
        var left: String
        var right: String
    
        init?(line: Substring) {
            guard let match = line.wholeMatch(of: /(\w+) = \((\w+), (\w+)\)/) else {
                return nil
            }
            name = match.1.string
            left = match.2.string
            right = match.3.string
        }
    }

}


