//
//  SendableBox.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/1/24.
//


final class SendableBox<T>: @unchecked Sendable {
    var value: T

    init(_ value: T) {
        self.value = value
    }
}
