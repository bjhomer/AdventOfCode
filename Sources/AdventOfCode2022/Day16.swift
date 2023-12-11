//
//  File.swift
//  
//
//  Created by BJ Homer on 12/16/22.
//

import Foundation
import AdventCore
import SwiftGraph
import Algorithms

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
        let result = solver.maxValue_part1()
        print(result)
    }

    func part2() async {
        let solver = DFSSolver(graph: graph)
        let result = solver.maxValue_part2()
        print(result)
    }
}

private class DFSSolver {

    private let graph: UnweightedGraph<Node>
    private let nodesByName: [String: Node]

    private var cache: [Situation: Int] = [:]
    private var cache2: [Situation2: Int] = [:]

    private var bestSoFar: Int = 0

    init(graph: UnweightedGraph<Node>) {
        self.graph = graph
        self.nodesByName = graph.vertices.keyed(by: \.name)
    }

    func maxValue_part1() -> Int {
        let availableNodes = Set(graph.vertices.filter { $0.flowRate > 0 })

        let start = nodesByName["AA"]!
        let situation = Situation(node: start, minutesRemaining: 30, availableNodes: availableNodes)
        return value(of: situation)
    }

    func maxValue_part2() -> Int {
        let availableNodes = Set(graph.vertices.filter { $0.flowRate > 0 })

        let start = nodesByName["AA"]!
        let situation = Situation2(node1: start, node2: start, minutesRemaining: 26, availableNodes: availableNodes, releasedSoFar: 0)
        return value(of: situation)
    }

    private struct Situation: Hashable, CustomStringConvertible {
        var node: Node
        var minutesRemaining: Int
        var availableNodes: Set<Node>

        var description: String {
            "\(minutesRemaining) \(node.name) -- \(availableNodes.map(\.name))"
        }
    }

    private struct Situation2: Hashable, CustomStringConvertible {
        var node1: Node
        var node2: Node
        var minutesRemaining: Int
        var availableNodes: Set<Node>
        var releasedSoFar: Int

        var description: String {
            "\(minutesRemaining) \(node1.name) \(node2.name) -- \(availableNodes.map(\.name))"
        }
    }


    private func value(of situation: Situation) -> Int {
        if let value = cache[situation] { return value }
        let minutesRemaining = situation.minutesRemaining
        if minutesRemaining <= 0 { return 0 }

        let availableNodes = situation.availableNodes
        let node = situation.node

        var options: [Int] = []
        if availableNodes.contains(node) {
            let activateValue = node.value(turnsActive: minutesRemaining - 1)
            let newSituation = Situation(node: node, minutesRemaining: minutesRemaining - 1, availableNodes: availableNodes.subtracting([node]))

            let totalValue = activateValue + value(of: newSituation)

            options.append( totalValue )
        }
        if let neighbors = graph.neighborsForVertex(node) {
            for neighbor in neighbors {
                let newSituation = Situation(node: neighbor, minutesRemaining: minutesRemaining - 1, availableNodes: availableNodes)
                let totalValue = value(of: newSituation)
                options.append(totalValue)
            }
        }

        let value = options.max() ?? 0
        cache[situation] = value
        return value
    }

    enum Action: Equatable {
        case activate, move(Node)
    }

    private func value(of situation: Situation2) -> Int {
        if let value = cache2[situation] { return value }

        let minutesRemaining = situation.minutesRemaining
        if minutesRemaining <= 0 { return 0 }

        let availableNodes = situation.availableNodes
        let node1 = situation.node1
        let node2 = situation.node2

        let bestPossibleOutcome = situation.releasedSoFar
        + availableNodes
            .map { $0.value(turnsActive: minutesRemaining - 1)}
            .reduce(0,+)

        if bestPossibleOutcome < bestSoFar {
            // This cannot possibly be the best. Bail early
            cache2[situation] = 0
            return 0
        }

        func availableActions(from node: Node) -> [Action] {
            var actions: [Action] = []
            if availableNodes.contains(node) { actions.append(.activate) }
            if let neighbors = graph.neighborsForVertex(node) {
                for neighbor in neighbors {
                    actions.append(.move(neighbor))
                }
            }
            return actions
        }

        let actions1 = availableActions(from: node1)
        let actions2 = availableActions(from: node2)

        var possibleMoves = Array(product(actions1, actions2))
        if node1 == node2,
           let index = possibleMoves.firstIndex(where: {$0 == .activate && $1 == .activate} ) {
            possibleMoves.remove(at: index)
        }

        var moveValues: [Int] = []

        for move in possibleMoves {
            var activateValue1 = 0
            var activateValue2 = 0

            var newAvailableNodes = situation.availableNodes

            var newNode1 = node1
            var newNode2 = node2

            switch move.0 {
            case .activate:
                activateValue1 = node1.value(turnsActive: minutesRemaining - 1)
                newAvailableNodes.remove(node1)
            case .move(let neighbor):
                newNode1 = neighbor
            }

            switch move.1 {
            case .activate:
                activateValue2 = node2.value(turnsActive: minutesRemaining - 1)
                newAvailableNodes.remove(node2)
            case .move(let neighbor):
                newNode2 = neighbor
            }

            let newlyActivatedValue = activateValue1 + activateValue2
            let newSituation = Situation2(node1: newNode1,
                                          node2: newNode2,
                                          minutesRemaining: minutesRemaining - 1,
                                          availableNodes: newAvailableNodes,
                                          releasedSoFar: situation.releasedSoFar + newlyActivatedValue)
            let totalValue = newlyActivatedValue + value(of: newSituation)
            moveValues.append(totalValue)
        }
        let value = moveValues.max() ?? 0
        cache2[situation] = value
        if value > bestSoFar {
            print("Found \(value)")
            bestSoFar = value
        }
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
