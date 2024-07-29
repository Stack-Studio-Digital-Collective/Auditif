//
//  Transcription.swift
//  Auditif
//
//  Created by Kevin Diem on 7/28/24.
//

import Foundation

struct Transcription: Codable, Identifiable, Equatable {
    var id = UUID()
    var title: String
    let createdAt: Date
    let segments: [IdentifiableSegment]
    
    static func == (lhs: Transcription, rhs: Transcription) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title
    }
}
