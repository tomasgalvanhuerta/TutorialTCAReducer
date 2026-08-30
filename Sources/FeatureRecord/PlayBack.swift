//
//  PlayBack.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 6/15/26.
//

import Foundation

/**
 ## Rules -
            1. PlayBack will fetch actions and resume based on 
 */

struct PlayBack {
    let rootAction: MainStateMachine.Action
    let record: Record
    
    var contents: [String] {
        guard let data = FileManager.default.contents(atPath: record.url.absoluteString),
              let content = String(data: data, encoding: .utf8) else {
            return []
        }
        
        return content.components(separatedBy: "\n")
    }
}
