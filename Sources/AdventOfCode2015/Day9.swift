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
    let bestPaths = graph.vertices.map { graph.shortestPathThroughAllNodes(from: $0) }
    let bestPath = bestPaths.min()!
    print("Part 1")
    print(bestPath)

    let worstPaths = graph.vertices.map { graph.longestPathThroughAllNodes(from: $0) }
    let worstPath = worstPaths.max()!
    print("Part 2")
    print(worstPath)

}


private extension WeightedGraph where W: Numeric & Comparable {

    convenience init(parsedLines: [ParsedLine]) where V == String, W == Int {
        self.init()
        let vertices = parsedLines.map(\.start) + parsedLines.map(\.end)
        for v in Set(vertices) {
            _ = self.addVertex(v)
        }

        for line in parsedLines {
            self.addEdge(from: line.start, to: line.end, weight: line.weight)
        }
    }

    func edge(from u: V, to v: V) -> E? {
        let destinationIndex = self.indexOfVertex(v)
        let candidates = self.edgesForVertex(u)
        return candidates?.first(where: { $0.v == destinationIndex })
    }

    func shortestPathThroughAllNodes(from start: V) -> Path {
        return bestPathThroughAllNodes(from: start, minFirst: true)
    }

    func longestPathThroughAllNodes(from start: V) -> Path {
        return bestPathThroughAllNodes(from: start, minFirst: false)
    }

    func bestPathThroughAllNodes(from start: V, minFirst: Bool) -> Path {

        var bestPathSoFar: Path? = nil

        var queue = PriorityQueue<Path>(ascending: minFirst)
        queue.push(Path(vertices: [start], cost: W.zero))

        while queue.isEmpty == false {
            guard let thisPath = queue.pop() else { break }

            if thisPath.vertices.count == self.vertices.count {
                if minFirst {
                    return thisPath
                }
                else {
                    if bestPathSoFar == nil || bestPathSoFar!.cost < thisPath.cost {
                        bestPathSoFar = thisPath
                    }
                }
            }

            print("  \(thisPath)")

            let lastVertex = thisPath.vertices.last!
            for neighbor in self.neighborsForVertex(lastVertex) ?? [] {
                if thisPath.vertices.contains(neighbor) { continue }
                guard let edge = self.edge(from: lastVertex, to: neighbor) else { continue }
                let newVertices = thisPath.vertices + [neighbor]
                let newCost = thisPath.cost + edge.weight

                let newPath = Path(vertices: newVertices, cost: newCost)
                queue.push(newPath)
            }
        }
        return bestPathSoFar!

    }

    struct PartialPath: Comparable {
        static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.lowerBound < rhs.lowerBound
        }

        var lowerBound: W
        var vertices: [V]
    }

    struct Path: CustomStringConvertible, Comparable {
        var vertices: [V]
        var cost: W

        var description: String {
            let nodes = vertices.map({ "\($0)" }).joined(separator: " > ")
            return "\(nodes) : \(cost)"
        }
        init(vertices: [V], cost: W) {
            self.vertices = vertices
            self.cost = cost
        }

        init(_ path: PartialPath) {
            self.vertices = path.vertices
            self.cost = path.lowerBound
        }

        static func < (lhs: Self, rhs: Self) -> Bool {
            return lhs.cost < rhs.cost
        }
    }

//    func lowerBoundCost(of partialPath: PartialPath) -> W {
//        let remainingVertices = self.vertices.filter({ partialPath.vertices.contains($0) == false })
//        guard remainingVertices.count > 0 else { return partialPath.lowerBound }
//
//        var bestLowerBound: W? = nil
//
//        let spanningTreeWeight = self.subgraph(including: vertices)
//            .mst()!
//            .map(\.weight)
//            .reduce(W.zero, +)
//
//
//        for destination in vertices {
//            let costIn = self.weights(from: origin, to: destination).first!
//            let costEstimate = costIn + spanningTreeWeight
//            if bestLowerBound == nil || costEstimate < bestLowerBound! {
//                bestLowerBound = costEstimate
//            }
//        }
//        return bestLowerBound!
//    }
//
//    func lowerBoundCost(from origin: V, through vertices: [V]) -> W {
//        var bestLowerBound: W? = nil
//
//        let spanningTreeWeight = self.subgraph(including: vertices)
//            .mst()!
//            .map(\.weight)
//            .reduce(W.zero, +)
//
//
//        for destination in vertices {
//            let costIn = self.weights(from: origin, to: destination).first!
//            let costEstimate = costIn + spanningTreeWeight
//            if bestLowerBound == nil || costEstimate < bestLowerBound! {
//                bestLowerBound = costEstimate
//            }
//        }
//        return bestLowerBound!
//    }
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
