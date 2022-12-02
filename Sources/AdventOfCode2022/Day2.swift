//
//  Day2.swift
//  
//
//  Created by BJ Homer on 12/1/22.
//

import Foundation
import Algorithms
import AsyncAlgorithms
import AdventCore

struct Day2: Day {

    private var lines: [Substring]

    init(input: URL) async throws {
        lines = try input.allLines
    }

    func part1() async {
        let matches: [RPS.Match] = lines.compactMap { moveLine in
            guard let (them, me) = moveLine.split(separator: " ").explode(),
                  let theirMove = RPS.Move(input: them),
                  let myMove = RPS.Move(input: me)
            else { return nil }

            return RPS.Match(myMove: myMove, theirMove: theirMove)
        }
        print(matches.map(\.value).reduce(0, +))
    }

    func part2() async {
        let matches = lines.compactMap { line -> RPS.Match? in
            guard let (a, x) = line.split(separator: " ").explode(),
                  let theirMove = RPS.Move(input: a),
                  let outcome = RPS.Outcome(x)
            else { return nil }
            return RPS.Match(theirMove: theirMove, desiredOutcome: outcome)
        }

        print(matches.map(\.value).reduce(0, +))
    }

}


private enum RPS {
    enum Move {
        case rock
        case paper
        case scissors

        init?(input: some StringProtocol) {
            switch input {
            case "A", "X": self = .rock
            case "B", "Y": self = .paper
            case "C", "Z": self = .scissors
            default: return nil
            }
        }

        var value: Int {
            switch self {
            case .rock: return 1
            case .paper: return 2
            case .scissors: return 3
            }
        }
    }

    enum Outcome {
        case win
        case lose
        case draw

        init?(_ input: some StringProtocol) {
            switch input {
            case "X": self = .lose
            case "Y": self = .draw
            case "Z": self = .win
            default: return nil
            }
        }

        var value: Int {
            switch self {
            case .win: return 6
            case .lose: return 0
            case .draw: return 3
            }
        }
    }

    struct Match {
        var myMove: Move
        var theirMove: Move
        var outcome: Outcome

        init(myMove: Move, theirMove: Move) {
            self.myMove = myMove
            self.theirMove = theirMove

            switch (myMove, theirMove) {
            case (.rock, .rock),
                (.paper, .paper),
                (.scissors, .scissors):
                self.outcome = .draw

            case (.rock, .paper),
                (.paper, .scissors),
                (.scissors, .rock):
                self.outcome = .lose

            case (.rock, .scissors),
                (.scissors, .paper),
                (.paper, .rock):
                self.outcome = .win
            }
        }

        init(theirMove: Move, desiredOutcome: Outcome) {
            self.theirMove = theirMove
            self.outcome = desiredOutcome

            switch (theirMove, desiredOutcome) {
            case (.rock, .win),
                (.paper, .draw),
                (.scissors, .lose):
                self.myMove = .paper

            case (.paper, .win),
                (.scissors, .draw),
                (.rock, .lose):
                self.myMove = .scissors

            case (.scissors, .win),
                (.rock, .draw),
                (.paper, .lose):
                self.myMove = .rock
            }
        }

        var value: Int {
            return myMove.value + outcome.value
        }
    }

}
