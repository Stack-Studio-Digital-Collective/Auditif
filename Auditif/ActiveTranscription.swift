//
//  ActiveTranscription.swift
//  Auditif
//
//  Created by Kevin Diem on 7/28/24.
//

import Foundation
import SwiftUI
import SwiftData
import SwiftWhisper
import AudioKit

struct ActiveTranscription: View {
    @State private var transcription: Transcription?
    @State private var filename = "No file selected"
    @State private var selectedFileURL: URL?
    @State private var title = ""
    
    @State private var loading = false
    @State private var failure = false
    @StateObject private var progress = TranscriptionProgress()
    
    @State private var transcriptionTask: Task<Void, Never>? = nil
    let transcriptionAdded: (Transcription) -> Void
    
    init(transcriptionAdded: @escaping(Transcription) -> Void) {
        self.transcriptionAdded = transcriptionAdded
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Transcription Name", text: $title)
            }
            .padding(.top)
            .padding(.horizontal)
            
            HStack {
                Text(filename)
                Button("Select a file") {
                    let panel = NSOpenPanel()
                    
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = false
                    panel.allowedContentTypes = [
                        .mp3,
                        .wav,
                        .mpeg4Audio
                    ]
                    
                    if panel.runModal() == .OK
                    {
                        DispatchQueue.main.async {
                            self.loading = true
                            
                            self.filename = panel.url?.lastPathComponent ?? ""
                            
                            self.selectedFileURL = panel.url
                            
                            if self.selectedFileURL != nil {
                                initialize()
                            }
                        }
                    }
                }
                .disabled(loading)
            }
            .padding()
            
            if (loading) {
                ProgressView(
                    value: progress.progress
                ).padding(.horizontal)
                Text(progress.status)
            } else if (failure) {
                Text("Failed to process audio")
            }
            
            List {
                ForEach(progress.segments) { segment in
                    Text(segment.text)
                }
            }
        }
    }
         
    func initialize() {
        self.progress.reset()
        
        transcriptionTask = Task {
            do {

                guard let modelURL = Bundle.main.url(
                    forResource: "ggml-small.en",
                    withExtension: "bin"
                ) else {
                    print("Model file not found")
                    DispatchQueue.main.async {
                        loading = false
                        failure = true
                    }
                    
                    return
                }
                
                let delegate = AuditifWhisperDelegate(progress: progress)
                let whisper = Whisper(fromFileURL: modelURL)
                
                whisper.delegate = delegate
                
                try await convertAndTranscribe(whisper: whisper)
                
                let _title = title.isEmpty ? generateTitle() : title
                
                transcriptionAdded(Transcription(
                    title: _title,
                    createdAt: Date.now,
                    segments: progress.segments
                ))
            } catch {
                print("Task failed: \(error)")
                failure = true
                loading = false
            }
        }
    }
    
    func generateTitle() -> String {
        let df = DateFormatter()
        
        df.dateStyle = .medium
        
        return "Transcription from \(df.string(from: Date.now))"
    }
    
    func convertAndTranscribe(whisper: Whisper) async throws {
        guard let url = selectedFileURL else {
            return
        }
        
        let floats = try await withCheckedThrowingContinuation { continuation in
            convertAudioFileToPCMArray(fileURL: url) { result in
                continuation.resume(with: result)
            }
        }
    
        let _ = try await whisper.transcribe(
            audioFrames: floats
        )
        
        DispatchQueue.main.async {
            loading = false
        }
    }
    
    func convertAudioFileToPCMArray(fileURL: URL, completionHandler: @escaping (Result<[Float], Error>) -> Void) {
        var options = FormatConverter.Options()
        options.format = .wav
        options.sampleRate = 16000
        options.bitDepth = 16
        options.channels = 1
        options.isInterleaved = false

        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        let converter = FormatConverter(inputURL: fileURL, outputURL: tempURL, options: options)
        converter.start { error in
            if let error {
                completionHandler(.failure(error))
                return
            }

            let data = try! Data(contentsOf: tempURL) // Handle error here

            let floats = stride(from: 44, to: data.count, by: 2).map {
                return data[$0..<$0 + 2].withUnsafeBytes {
                    let short = Int16(littleEndian: $0.load(as: Int16.self))
                    return max(-1.0, min(Float(short) / 32767.0, 1.0))
                }
            }

            try? FileManager.default.removeItem(at: tempURL)

            completionHandler(.success(floats))
        }
    }
}
