//
//  Record.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 6/15/26.
//

import Foundation
import ComposableArchitecture


struct Record: Equatable {
    let url: URL
    init (url: URL) {
        self.url = url
    }
    
    init() throws {
        self.url = try Self.newFile()
    }
}

extension Record {
    static func newFile() throws -> URL {
        let directoryName = "Records \(UUID().uuidString)"
        let fileName = "\(Date().formatted(.dateTime)).txt"
        
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            // Fallback to temporary directory
            return FileManager.default.temporaryDirectory
                .appendingPathComponent(directoryName)
                .appendingPathComponent(fileName, conformingTo: .text)
        }
        
        // Create the Records directory if it doesn't exist
        let recordsDirectory = documentsURL.appendingPathComponent(directoryName, isDirectory: true)
        try FileManager.default.createDirectory(at: recordsDirectory, withIntermediateDirectories: true)
        
        return recordsDirectory.appendingPathComponent(fileName, conformingTo: .text)
    }
    
    static func writeTo(url: URL, action: String) throws {
        try "\(action)\n".write(to: url, atomically: true, encoding: .utf8)
    }
}

extension Record {
    public func write(action: String) throws {
        try Record.writeTo(url: url, action: action)
    }
}
