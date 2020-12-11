//
//  File.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation
import AdventCore
import Algorithms



func day9(input: String) {

}


struct Edge: Hashable {
    var from: String
    var to: String
}

private struct Graph {
    var nodes: [String]
    var edges: [Edge: Int]

    func cost(from: String, to: String) -> Int {
        let edge = Edge(from: from, to: to)
        return edges[edge]!
    }

    func costs(from: String) -> [(String, Int)] {
        let costs = edges.keys
            .filter { $0.from == from }
            .map { ($0.to, edges[$0]!) }
        return costs
    }
}

//private struct Tour {
//    var graph: Graph
//    var nodes: [String]
//}
