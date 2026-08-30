//
//  Interaction.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 6/22/26.
//

import Foundation

/// Create a Macro that converts each name into a description
/// If associated value do not create
/// initiate with string and allow a default value
protocol Interaction { // Trace?
    associatedtype Root
    var value: String { get }
    
    /// Using initializer
    init(value: String)
    
    /// Default value if the Initializer with a ``init(value:)`` can not
    init()
}

