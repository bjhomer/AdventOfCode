//
//  Day7.swift
//  
//
//  Created by BJ Homer on 12/3/22.
//

import Foundation
import RegexBuilder

struct Day7: Day {

    private var root: Directory

    init(input: URL) async throws {
        let lines = try input.allLines

        root = TerminalParser().parse(lines: lines)
    }
    
    func part1() async {

        let smallishDirectories = root.recursiveDirectories.filter { $0.size <= 100_000 }
        let answer = smallishDirectories.map(\.size).reduce(0, +)
        print(answer)
    }
    
    func part2() async {
        let totalCapacity = 70_000_000
        let spaceRequired = 30_000_000

        let currentSpaceAvailable = totalCapacity - root.size
        let amountToFree = spaceRequired - currentSpaceAvailable

        let answer = root.recursiveDirectories
            .filter { $0.size >= amountToFree }
            .sorted(on: \.size)
            .first!
            .size

        print(answer)
    }
}

private struct TerminalParser {
    var terminal = Terminal()

    func parse(lines: [some StringProtocol]) -> Directory {
        var lines = lines[...]

        while let line = lines.popFirst() {
            let command = Command(line)
            switch command {
            case .cd(name: let name):
                terminal.changeDirectory(name)

            case .ls:
                while let line = lines.first,
                      let result = LSOutputLine(line) {
                    terminal.currentDirectory.add(result.item)
                    lines.removeFirst()
                }

            case nil:
                print("Unexpected line:", line)
                break
            }

        }
        return terminal.rootDirectory
    }
}


private enum Command: CustomStringConvertible {
    case cd(name: String)
    case ls

    init?(_ str: some StringProtocol) {
        let s = String(str)
        if s == "$ ls" {
            self = .ls
        }
        else if let match = s.wholeMatch(of: #/\$ cd (.+)/#) {
            let name = String(match.1)
            self = .cd(name: name)
        }
        else {
            return nil
        }
    }

    var description: String {
        switch self {
        case .cd(name: let name): return "cd \(name)"
        case .ls: return "ls"
        }
    }
}

private struct LSOutputLine {
    var item: FSItem
    init?(_ line: some StringProtocol) {
        let s = String(line)
        if let match = s.wholeMatch(of: #/dir (\w+)/#) {
            let name = String(match.1)
            item = Directory(name: name)
        }
        else if let match = s.wholeMatch(of: #/(\d+) (.+)/#) {
            let size = Int(match.1)!
            let name = String(match.2)
            item = File(name: name, size: size)
        }
        else {
            return nil
        }
    }
}

private class Terminal {
    var currentPath: [Directory] = []
    var currentDirectory: Directory { currentPath.last ?? rootDirectory }

    var rootDirectory: Directory = Directory.root

    func changeDirectory(_ name: String) {
        switch name {
        case "..":
            currentPath.removeLast()
        case "/":
            currentPath = []
        default:
            let dir = currentDirectory.directory(named: name)
            currentPath.append(dir)
        }
    }
}


private protocol FSItem {
    var name: String { get }
    var size: Int { get }
}

private struct File: FSItem {
    var name: String
    var size: Int
}

private class Directory: FSItem {
    var name: String
    var contents: [any FSItem] = []

    var size: Int {
        return contents.map(\.size).reduce(0, +)
    }

    init(name: String) {
        self.name = name
    }

    func add(_ item: any FSItem) {
        contents.append(item)
    }

    func directory(named name: String) -> Directory {
        if let dir = contents.first(where: { $0.name == name }) {
            return dir as! Directory
        }
        else {
            let dir = Directory(name: name)
            contents.append(dir)
            return dir
        }
    }

    var childDirectories: [Directory] {
        return contents.compactMap { $0 as? Directory }
    }

    var recursiveDirectories: [Directory] {
        return [self] + childDirectories.map(\.recursiveDirectories).reduce([], +)
    }

    static var root: Directory {
        return Directory(name: "")
    }
}
