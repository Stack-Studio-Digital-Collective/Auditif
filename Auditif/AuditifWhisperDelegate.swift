//
//  AuditifWhisperDelegate.swift
//  Auditif
//
//  Created by Kevin Diem on 7/28/24.
//

import Foundation
import SwiftUI
import SwiftWhisper

class TranscriptionProgress: ObservableObject {
    @Published var progress: Double = 0.0
    @Published var status: String = "Progress: 0%"
    @Published var segments: [IdentifiableSegment] = []
    
    func reset() {
        self.progress = 0.0
        self.status = "Progess: 0%"
        self.segments = []
    }
}

class AuditifWhisperDelegate: WhisperDelegate {
    @ObservedObject var progress: TranscriptionProgress
    
    init(progress: TranscriptionProgress) {
        self.progress = progress
    }
    
    func whisper(_ aWhisper: Whisper, didUpdateProgress progress: Double) {
        DispatchQueue.main.async {
            self.progress.progress = progress
            self.progress.status = "Progress: \(Int(progress * 100))%"
            print("Progress reported \(progress)")
        }
    }
    
    func whisper(_ aWhisper: Whisper, didProcessNewSegments segments: [Segment], atIndex index: Int) {
        self.progress.segments.append(contentsOf: segments.map({ segment in
            return IdentifiableSegment(startTime: segment.startTime, endTime: segment.endTime, text: segment.text)
        }))
    }
    
    func whisper(_ aWhisper: Whisper, didCompleteWithSegments segments: [Segment]) {
        DispatchQueue.main.async {
            self.progress.status = "Transcription Complete"
        }
    }
    
    func whisper(_ aWhisper: Whisper, didErrorWith error: Error) {
        DispatchQueue.main.async {
            self.progress.status = "Error: \(error.localizedDescription)"
        }
    }
}
