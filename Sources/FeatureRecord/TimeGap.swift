//
//  TimeGap.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 6/22/26.
//

import Foundation

struct TimeGap: RawRepresentable {
    let rawValue: Double
    
    typealias RawValue = Double
    
    var writeDescription: String {
        return "Time: \(rawValue)"
    }
    
    init(rawValue: Double) {
        self.rawValue = rawValue
    }
    
    init(value: String) {
        // Parse "Time: <number>" format
        // Remove "Time: " prefix and parse the remaining number
        let trimmed = value.replacingOccurrences(of: "Time: ", with: "")
        self.rawValue = Double(trimmed) ?? 0.0
    }
}
