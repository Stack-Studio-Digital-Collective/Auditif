//
//  TranscriptionStore.swift
//  Auditif
//
//  Created by Kevin Diem on 7/28/24.
//

import Foundation

class TranscriptionStore: ObservableObject {
    @Published var transcriptions: [Transcription] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("transcriptions.data")
    }
    
    func load() async throws {
        let task = Task<[Transcription], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let transcriptions = try JSONDecoder().decode([Transcription].self, from: data)
            return transcriptions
        }
        
        let transcriptions = try await task.value
        
        DispatchQueue.main.async {
            self.transcriptions = transcriptions
        }
    }
    
    func save(transcriptions: [Transcription]) async throws {
        let data = try JSONEncoder().encode(transcriptions)
        let outfile = try Self.fileURL()
        try data.write(to: outfile)
    }
}
