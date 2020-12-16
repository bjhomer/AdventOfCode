//
//  File.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation
import AdventCore
import Algorithms
import SwiftGraph


func day9(input: String) {

    let lines = input.split(separator: "\n")
        .compactMap(ParsedLine.init(line:))


    let graph = WeightedGraph<String, Int>(parsedLines: lines)
}

private extension WeightedGraph where W: AdditiveArithmetic & Comparable {

    convenience init(parsedLines: [ParsedLine]) where V == String, W == Int {
        self.init()
        for line in parsedLines {
            self.addEdge(from: line.start, to: line.end, weight: line.weight)
        }
    }

    func subgraph(including vertices: [V]) -> WeightedGraph<V, W> {
        let graph = WeightedGraph<V, W>()

        for edge in self.edgeList() {
            let start = vertexAtIndex(edge.u)
            let end = vertexAtIndex(edge.v)
            if vertices.contains(start) && vertices.contains(end) {
                graph.addEdge(from: start, to: end, weight: edge.weight)
            }
        }
        return graph
    }

    func shortestPathThroughAllNodes(from start: V, to end: V) -> [V] {

        var bestPathSoFar: Path?

        var queue = PriorityQueue<PartialPath>()
        queue.push(PartialPath(lowerBound: W.zero, vertices: [start]))

        while queue.isEmpty == false {
            guard let partialPath = queue.pop() else { break }

            guard bestPathSoFar == nil || partialPath.lowerBound < bestPathSoFar!.cost else { continue }

            if partialPath.vertices.count == self.vertices.count {
                bestPathSoFar = Path(partialPath)
            }

            let lastVertex = partialPath.vertices.last!
            for neighbor in self.neighborsForVertex(lastVertex) {
                if partialPath.vertices.contains(neighbor) { continue }
                let newPath = partialPath.vertices + [neighbor]
                let remainingVertices = vertices.removeAll(where: { newPath.vertices.contains($0) })
                let newCost = self.lowerBoundCost(from: neighbor, through: remainingVertices)
            }


        }



    }

    struct PartialPath: Comparable {
        static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.lowerBound < rhs.lowerBound
        }

        var lowerBound: W
        var vertices: [V]
    }

    struct Path {
        var vertices: [V]
        var cost: W

        init(_ partialPath: PartialPath) {
            vertices = partialPath.vertices
            cost = partialPath.lowerBound
        }
    }

    func lowerBoundCost(of partialPath: PartialPath) -> W {
        let remainingVertices = self.vertices.filter({ partialPath.vertices.contains($0) == false })
        guard remainingVertices.count > 0 else { return partialPath.lowerBound }

        var bestLowerBound: W? = nil

        let spanningTreeWeight = self.subgraph(including: vertices)
            .mst()!
            .map(\.weight)
            .reduce(W.zero, +)


        for destination in vertices {
            let costIn = self.weights(from: origin, to: destination).first!
            let costEstimate = costIn + spanningTreeWeight
            if bestLowerBound == nil || costEstimate < bestLowerBound! {
                bestLowerBound = costEstimate
            }
        }
        return bestLowerBound!
    }

    func lowerBoundCost(from origin: V, through vertices: [V]) -> W {
        var bestLowerBound: W? = nil

        let spanningTreeWeight = self.subgraph(including: vertices)
            .mst()!
            .map(\.weight)
            .reduce(W.zero, +)


        for destination in vertices {
            let costIn = self.weights(from: origin, to: destination).first!
            let costEstimate = costIn + spanningTreeWeight
            if bestLowerBound == nil || costEstimate < bestLowerBound! {
                bestLowerBound = costEstimate
            }
        }
        return bestLowerBound!
    }
}

private struct ParsedLine {
    var start: String
    var end: String
    var weight: Int

    init?<Str>(line: Str) where Str: StringProtocol {
        let regex: Regex = #"(.+) to (.+) = (\d+)"#

        guard let match = regex.match(line),
              case let start = match[1],
              case let end = match[2],
              let weight = Int(match[3])
        else { return nil }

        self.start = start
        self.end = end
        self.weight = weight
    }

}

//struct Edge: Hashable {
//    var from: String
//    var to: String
//}
//
//private struct Graph {
//    var nodes: [String]
//    var edges: [Edge: Int]
//
//    func cost(from: String, to: String) -> Int {
//        let edge = Edge(from: from, to: to)
//        return edges[edge]!
//    }
//
//    func costs(from: String, to: [String]? = nil) -> [(String, Int)] {
//        let costs = edges.keys
//            .filter { $0.from == from && (to?.contains($0.to) ?? true) }
//            .map { ($0.to, edges[$0]!) }
//        return costs
//    }
//

//
//}
//
//
//
