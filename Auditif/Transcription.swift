//
//  Transcription.swift
//  Auditif
//
//  Created by Kevin Diem on 7/28/24.
//

import Foundation

struct ExecutionTime: Codable {
    let startup: Double
    let audioProcessing: Double
    let transcription: Double
}

struct Transcription: Codable, Identifiable, Equatable {
    var id = UUID()
    var title: String
    let createdAt: Date
    let executionTime: ExecutionTime?
    let segments: [IdentifiableSegment]
    
    static func == (lhs: Transcription, rhs: Transcription) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title
    }
}
