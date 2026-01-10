//
//  Day08.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/2025.
//

import Foundation
import Algorithms
import AdventCore
import Graphs

struct Day08: AdventDay {
    
    var data: String
    
    init(data: String) {
        self.data = data
    }
    
    func part1() -> Int {
        return part1(connectionCount: 1000)
    }
    
    func part1(connectionCount: Int) -> Int {
        var graph = AdjacencyList()
        for line in data.lines {
            guard let (x, y, z) = line
                .split(separator:",")
                .compactMap({ Double(String($0)) })
                .explode()
            else {
                continue
            }
            graph.addVertex {
                $0.x = x
                $0.y = y
                $0.z = z
            }
        }
        
        var potentialEdges = Heap<PotentialEdge>(minimumCapacity: graph.vertexCount * graph.vertexCount)
        
        
        for pair in graph.vertices().combinations(ofCount: 2) {
            guard let (u, v) = pair.explode() else {
                continue
            }
            
            let x = graph[u].x - graph[v].x
            let y = graph[u].y - graph[v].y
            let z = graph[u].z - graph[v].z
            
            let distance = hypot(hypot(x, y), z)
            let edge = PotentialEdge(a: u, b: v, weight: distance)
            potentialEdges.insert(edge)
        }
        
        for _ in 0..<connectionCount {
            guard let edge = potentialEdges.popMin() else { break }
            graph.addEdge(from: edge.a, to: edge.b) { $0.weight = edge.weight }
            graph.addEdge(from: edge.b, to: edge.a) { $0.weight = edge.weight }
        }
        
        
        let components = graph
            .connectedComponents(using: .unionFind())
            .components
        
        let biggestThree = components
            .max(count: 3) { (a, b) in a.count < b.count }
        
        
        return biggestThree
            .map { $0.count }
            .reduce(1, *)
    }
    
    func part2() -> Int {
        
        var vertices: [Vertex2] = Array()
        
        for (idx, line) in data.lines.enumerated() {
            guard let (x, y, z) = line
                .split(separator:",")
                .compactMap({ Double(String($0)) })
                .explode()
            else {
                continue
            }
            
            let vertex = Vertex2(id: idx, x: x, y: y, z: z, cluster: idx)
            vertices.append(vertex)
        }
        
        var potentialEdges = Heap<PotentialEdge2>(minimumCapacity: vertices.count * vertices.count)
        
        
        for pair in vertices.combinations(ofCount: 2) {
            guard let (u, v) = pair.explode() else {
                continue
            }
            
            let x = u.x - v.x
            let y = u.y - v.y
            let z = u.z - v.z
            
            let distance = hypot(hypot(x, y), z)
            let edge = PotentialEdge2(a: u.id, b: v.id, weight: distance)
            potentialEdges.insert(edge)
        }
        
        repeat {
            guard let edge = potentialEdges.popMin() else { break }
            
            let aID = edge.a
            let bID = edge.b
            
            let aCluster = vertices[aID].cluster
            let bCluster = vertices[bID].cluster
            
            if aCluster == bCluster {
                continue
            }
            else {
                let (newID, oldID) = [aCluster, bCluster].minAndMax()!
                
                for i in vertices.indices where vertices[i].cluster == oldID {
                    vertices[i].cluster = newID
                }
            }
            
            if vertices.allSatisfy({ $0.cluster == 0 }) {
                return Int(vertices[aID].x * vertices[bID].x)
            }
        } while true
        
        return 0
    }
}

extension Day08 {
    struct PotentialEdge: Comparable {
        static func < (lhs: Day08.PotentialEdge, rhs: Day08.PotentialEdge) -> Bool {
            return lhs.weight < rhs.weight
        }
        
        static func == (lhs: Day08.PotentialEdge, rhs: Day08.PotentialEdge) -> Bool {
            return lhs.weight == rhs.weight
        }
        
        var a: OrderedVertexStorage.Vertex
        var b: OrderedVertexStorage.Vertex
        var weight: Double
        
        init(a: OrderedVertexStorage.Vertex,
             b: OrderedVertexStorage.Vertex,
             weight: Double)
        {
            self.a = a
            self.b = b
            self.weight = weight
        }
    }
    
    struct Vertex2 {
        var id: Int
        var x: Double
        var y: Double
        var z: Double
        var cluster: Int
    }
    
    struct PotentialEdge2: Comparable {
        var a: Int
        var b: Int
        var weight: Double
        
        static func < (lhs: Day08.PotentialEdge2, rhs: Day08.PotentialEdge2) -> Bool {
            return lhs.weight < rhs.weight
        }
    }
}


enum PositionX: VertexProperty {
    static var defaultValue: Double { 0 }
}
enum PositionY: VertexProperty {
    static var defaultValue: Double { 0 }
}
enum PositionZ: VertexProperty {
    static var defaultValue: Double { 0 }
}

enum Weight: EdgeProperty {
    static var defaultValue: Double { 0 }
}



private extension VertexPropertyValues {
    var x: Double {
        get { self[PositionX.self] }
        set { self[PositionX.self] = newValue }
    }
    
    var y: Double {
        get { self[PositionY.self] }
        set { self[PositionY.self] = newValue }
    }
    
    var z: Double {
        get { self[PositionZ.self] }
        set { self[PositionZ.self] = newValue }
    }
}

private extension EdgePropertyValues {
    var weight: Double {
        get { self[Weight.self] }
        set { self[Weight.self] = newValue }
    }
}
