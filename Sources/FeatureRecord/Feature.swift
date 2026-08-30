//
//  FileManagement.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 6/15/26.
//

import Foundation
import ComposableArchitecture

struct UserInteractionRecorder<State, Action>: Reducer {
    // Record with time differnce
    // Feature Record
    
    let record: Record
    let log = LoggingCoordinator(logger: .init(label: "UserInteractionRecorder"))
    let date: Date? = nil
    
    /// Specific location to write action
    public init(url: URL) {
        self.record = .init(url: url)
    }
    
    /// Use the same location to write as the ``Record``
    public init(record: Record) {
        self.record = record
    }
    
    /// Creates a new file with name "Records { Random UUID }"
    /// Able to throw
    public init() throws {
        self.record = try .init()
    }
    
    /**
     ## Rules -
                1. Will space the time based on the previous time stamp
     */
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        /// There is a bit of overhead...
        interaction(action)
        return .none
    }
}

extension UserInteractionRecorder {
    func interaction(_ action: Action) {
        if let action = action as? (any Interaction) {
            do {
                try record.write(action: action.value)
            } catch {
                log.error("Error trying to write action: \(error)")
            }
        }
    }
    
    func addTimeGap(to date: Date) -> TimeGap {
        Self.timeGap(date)
    }
    
    static func timeGap(_ date: Date) -> TimeGap {
        let timegap = TimeGap(rawValue: date.timeIntervalSince(Date()))
        return timegap
    }
}


