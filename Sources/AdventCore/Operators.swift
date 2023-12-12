//
//  File.swift
//  
//
//  Created by BJ Homer on 12/12/22.
//

import Foundation

infix operator =>

public func => <T, U> (lhs: T, rhs: (T)->U) -> U {
    return rhs(lhs)
}



precedencegroup ForwardPipe {
    associativity: left
}

infix operator |>: ForwardPipe

public func |> <T, U> (value: T, transform: (T)->U) -> U {
    return transform(value)
}




