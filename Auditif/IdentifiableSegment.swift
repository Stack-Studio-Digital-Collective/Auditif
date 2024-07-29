//
//  IdentifiableSegment.swift
//  Auditif
//
//  Created by Kevin Diem on 7/28/24.
//

import Foundation

struct IdentifiableSegment: Identifiable, Codable {
    public var id = UUID()
    public let startTime: Int
    public let endTime: Int
    public let text: String
}
