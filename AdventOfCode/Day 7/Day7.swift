//
//  Day7.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/23/17.
//  Copyright © 2017 BJ Homer. All rights reserved.
//

import Foundation

func day7() {
    
    class Node: CustomStringConvertible {
        var parent: Node? = nil
        var children: [Node] = []
        var name: String
        var ownWeight: Int
        var childNames: [String]
        
        var description: String {
            return "\(name) (\(ownWeight)) -> [\(children.map({$0.name}).joined(separator: ", "))]"
        }
        
        lazy var weight: Int = {
            return ownWeight + children.reduce(0, { $0 + $1.weight })
        }()
        
        init?(description: String) {
            let regex = try! NSRegularExpression(pattern: """
                (.*?)\\ #name
                \\((\\d+)\\) # weight
                (?: # start optional children
                  (?:\\ ->\\ ) # arrow
                  (.*+) # names
                )?
                """, options: [.allowCommentsAndWhitespace])
            
            
            guard let match = regex.firstMatch(in: description) else { return nil }
            let nameRange = match.range(at: 1)
            let weightRange = match.range(at: 2)
            
            name = String(description[Range(nameRange, in: description)!])
            ownWeight = Int(description[Range(weightRange, in: description)!])!
            
            if match.range(at: 3).length > 0 {
                let childrenRange = match.range(at: 3)
                let childNamesStr = description[Range(childrenRange, in: description)!]
                childNames = childNamesStr.components(separatedBy: ", ")
            }
            else {
                childNames = []
            }
        }
        
        func connectChild(_ node: Node) {
            assert(childNames.contains(node.name))
            children.append(node)
            node.parent = self
        }
        
        var isBalanced: Bool {
            let weights = children.map({ $0.weight })
            if Set(weights).count != 1 {
                return false
            }
            return true
        }
        
        var unbalancedChild: Node? {
            if self.isBalanced { return nil }
            if let badChild = children.filter({ $0.isBalanced == false }).first {
                return badChild
            }
            return nil
        }
        
        var unbalancedDescendant: Node? {
            if self.isBalanced { return nil }
            var node = self
            while let nextNode = node.unbalancedChild {
                node = nextNode
            }
            return node
        }
    }
    
    let inputURL = Bundle.main.url(forResource: "Day7Input", withExtension: "txt")!
    let input = try! String(contentsOf: inputURL)
    
    let lines = input.components(separatedBy: "\n")
    
    let nodes = lines.flatMap(Node.init)
    var nodesByName: [String: Node] = [:]
    
    for node in nodes {
        nodesByName[node.name] = node
    }
    
    for node in nodes {
        for childName in node.childNames {
            let childNode = nodesByName[childName]!
            node.connectChild(childNode)
        }
    }
    
    var root = nodes.first!
    while let next = root.parent {
        root = next
    }
    
    print("Root node: \(root.name)")
    print("Is balanced? \(root.isBalanced)")

    if let unbalancedDescendant = root.unbalancedDescendant {
        print("child weights: \(unbalancedDescendant.children.map({ $0.weight }))")
        print("child own weights: \(unbalancedDescendant.children.map({ $0.ownWeight }))")
    }
}
