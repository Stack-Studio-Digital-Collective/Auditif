//
//  SmartTranscriberApp.swift
//  SmartTranscriber
//
//  Created by Kevin Diem on 7/27/24.
//

import SwiftUI
import SwiftData

@main
struct AuditifApp: App {
    @StateObject private var store = TranscriptionStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                transcriptions: $store.transcriptions
            )
            .task {
                do {
                    try await store.load()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
            .onChange(of: store.transcriptions, {
                saveState()
            })
        }
    }
    
    private func saveState() {
        Task {
            do {
                try await store.save(transcriptions: store.transcriptions)
            } catch {
                print("Failed to save state \(error)")
            }
        }
    }
}
