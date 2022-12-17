//
//  File.swift
//  
//
//  Created by BJ Homer on 12/16/22.
//

import Foundation
import AdventCore
import SwiftGraph

struct Day16: Day {

    private let nodes: [Node]
    private let edges: [Edge]
    private let nodesByName: [String: Node]
    private var graph: UnweightedGraph<Node>

    init(input: URL) async throws {
        let descriptions = try input.allLines
            .compactMap { NodeDescription($0) }

        self.nodes = descriptions.map(\.node)
        self.edges = descriptions.flatMap(\.edges)
        self.nodesByName = nodes.keyed(by: \.name)

        let graph = UnweightedGraph<Node>()
        for node in nodes {
            _ = graph.addVertex(node)
        }

        for edge in edges {
            let start = nodesByName[edge.start]!
            let end   = nodesByName[edge.end]!
            graph.addEdge(from: start, to: end)
        }
        self.graph = graph
    }

    func part1() async {
        let solver = DFSSolver(graph: graph)
        let result = solver.maxValue()
        print(result)
    }

    func solvePart1ByHighestValue() async {
        var activeNodes: [Node] { nodes.filter { $0.isActive } }
        var inactiveNodes: [Node] { nodes.filter { $0.isActive == false }}

        var turnsRemaining = 30

        var pressureReleased = 0

        var current = nodesByName["AA"]!
        while turnsRemaining > 0 {
            let bestMove = inactiveNodes
                .compactMap {node in
                    let x = value(of: node, from: current, turnsRemaining: turnsRemaining)
                    print("   At turn \(turnsRemaining), \(node.name) has value \(x?.value ?? 0)")
                    return x
                }
                .sorted(on: \.value)
                .last!

            print("\nTurn \(turnsRemaining):")
            print("--------")
            print("Moved to \(bestMove.destination.name), costing \(bestMove.duration) turns")
            print("Activated for \(bestMove.value) pressure")
            turnsRemaining -= bestMove.duration
            pressureReleased += bestMove.value
            bestMove.destination.isActive = true
            current = bestMove.destination
            print("Total pressure released: \(pressureReleased)")
        }

        print()
        print(pressureReleased)

    }

    func part2() async {

    }

    private func turns(from: Node, to: Node) -> Int {
        return graph.bfs(from: from, to: to).count
    }

    private func value(of target: Node, from: Node, turnsRemaining: Int) -> MoveValue? {
        let distance = turns(from: from, to: target)
        if distance >= turnsRemaining { return nil }

        let turnsActive = (turnsRemaining - distance - 1)
        let value = target.value(turnsActive: turnsActive)

        let result = MoveValue(value: value, duration: distance + 1, destination: target)
        return result
    }

    private func node(_ str: String) -> Node {
        nodesByName[str]!
    }

}

private class DFSSolver {

    private let graph: UnweightedGraph<Node>
    private let nodesByName: [String: Node]

    private var cache: [Situation: Int] = [:]

    init(graph: UnweightedGraph<Node>) {
        self.graph = graph
        self.nodesByName = graph.vertices.keyed(by: \.name)
    }

    func maxValue() -> Int {
        let availableNodes = Set(graph.vertices.filter { $0.flowRate > 0 })

        let start = nodesByName["AA"]!
        let situation = Situation(node: start, minutesRemaining: 30, availableNodes: availableNodes)
        return value(of: situation)
    }

    private enum Action: Equatable {
        case activate, move(Node)
    }

    private struct Situation: Hashable, CustomStringConvertible {
        var node: Node
        var minutesRemaining: Int
        var availableNodes: Set<Node>

        var description: String {
            "\(minutesRemaining) \(node.name) -- \(availableNodes.map(\.name))"
        }
    }


    private func value(of situation: Situation) -> Int {
        if let value = cache[situation] { return value }
        let minutesRemaining = situation.minutesRemaining
        if minutesRemaining <= 0 { return 0 }

        let availableNodes = situation.availableNodes
        let node = situation.node

        var options: [(Action, Int)] = []
        if availableNodes.contains(node) {
            let activateValue = node.value(turnsActive: minutesRemaining - 1)
            let newSituation = Situation(node: node, minutesRemaining: minutesRemaining - 1, availableNodes: availableNodes.subtracting([node]))

            let totalValue = activateValue + value(of: newSituation)

            options.append( (.activate, totalValue) )
        }
        if let neighbors = graph.neighborsForVertex(node) {
            for neighbor in neighbors {
                let newSituation = Situation(node: neighbor, minutesRemaining: minutesRemaining - 1, availableNodes: availableNodes)
                let totalValue = value(of: newSituation)
                options.append( (.move(neighbor), totalValue) )
            }
        }

        let value = options.sorted(on: \.1).last?.1 ?? 0
        cache[situation] = value
        return value

    }


}


private struct MoveValue {
    var value: Int
    var duration: Int
    var destination: Node
}

private struct NodeDescription {

    var node: Node
    var edges: [Edge]

    // Valve II has flow rate=0; tunnels lead to valves AA, JJ
    init?(_ line: some StringProtocol) {
        let regex = #/Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)/#
        if let match = try? regex.wholeMatch(in: String(line)) {
            let node = Node(name: String(match.1), flowRate: Int(match.2)!)
            self.edges = match.3.split(separator: ", ")
                .map { Edge(start: node.name, end: String($0)) }
            self.node = node
        }
        else {
            return nil
        }
    }
}

private class Node: Hashable, Codable {
    var name: String
    var flowRate: Int

    var isActive: Bool = false


    init(name: String, flowRate: Int) {
        self.name = name
        self.flowRate = flowRate
    }


    func value(turnsActive: Int) -> Int {
        return turnsActive * flowRate
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

private class Edge: Equatable, Codable {
    var start: String
    var end: String

    static func == (lhs: Edge, rhs: Edge) -> Bool {
        lhs.start == rhs.start && lhs.end == rhs.end
    }
    internal init(start: String, end: String) {
        self.start = start
        self.end = end
    }

}
