//
//  ContentView.swift
//  Auditif
//
//  Created by Kevin Diem on 7/27/24.
//

import SwiftUI
import SwiftData
import SwiftWhisper
import AudioKit

struct ContentView: View {
    @Binding var transcriptions: [Transcription]
    @State var activeTranscription: Transcription?
    @State var transcriptionToDelete: Transcription?
    @State var showingDeleteDialog = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    private let dateFormatter: DateFormatter
    
    init(transcriptions: Binding<[Transcription]>) {
        self._transcriptions = transcriptions
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .short
    }
    
    var activeTranscriptionBinding: Binding<Transcription> {
        Binding(
            get: { self.activeTranscription ?? Transcription(
                title: "",
                createdAt: Date(),
                executionTime: nil,
                segments: []
            )},
            set: { newValue in
                self.activeTranscription = newValue
                if let index = self.transcriptions.firstIndex(where: { $0.id == newValue.id }) {
                    self.transcriptions[index] = newValue
                }
            }
        )
    }
    
    var body: some View {
        NavigationSplitView(sidebar: {
            ZStack {
                List {
                    ForEach(
                        transcriptions.sorted(by: {$0.createdAt > $1.createdAt})
                    ) { transcription in
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(activeTranscription == transcription ? Color.blue.opacity(0.3) : Color.clear)
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    activeTranscription = transcription
                                }
                            
                            VStack(alignment: .leading) {
                                Text(transcription.title)
                                    .font(.headline)
                                
                                Text(dateFormatter.string(from: transcription.createdAt))
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .onTapGesture {
                                activeTranscription = transcription
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive, action: {
                                    transcriptionToDelete = transcription
                                    showingDeleteDialog = true
                                }, label: {
                                    Label("Delete", systemImage: "trash")
                                })
                                
                            }
                        }
                        .onTapGesture {
                            activeTranscription = transcription
                        }
                    }
                }.confirmationDialog("Delete transcript?", isPresented: $showingDeleteDialog, actions: {
                    Button("Delete", role: .destructive) {
                        if transcriptionToDelete == nil {
                            return
                        }
                        
                        if transcriptionToDelete == activeTranscription {
                            self.activeTranscription = nil
                        }
                        
                        if let index = transcriptions.firstIndex(
                            where: { $0 == transcriptionToDelete!}) {
                            transcriptions.remove(at: index)
                        }
                        
                        showingDeleteDialog = false
                    }
                    Button("Cancel", role: .cancel) {
                        showingDeleteDialog = false
                    }
                })
            }
        }, detail: {
            ZStack {
                if (activeTranscription != nil) {
                    TranscriptionDetail(transcription: activeTranscriptionBinding, remove: {
                        guard let index = transcriptions.firstIndex(where: { t in
                            t.id == activeTranscription?.id
                        }) else {
                            return
                        }
                        
                        self.activeTranscription = nil
                        transcriptions.remove(at: index)
                    })
                } else {
                    ActiveTranscription(
                        transcriptionAdded: { transcription in
                            self.transcriptions.append(transcription)
                            self.activeTranscription = transcription
                        }
                    )
                }
            }
        })
        .navigationTitle(activeTranscription?.title ?? "New Transcription")
        .toolbar(content: {
            ToolbarItem(placement: .navigation) {
                Image(systemName: "plus")
                    .onTapGesture {
                        activeTranscription = nil
                    }
                    .disabled(activeTranscription == nil)
            }
        })
    }
}

#Preview {
    struct ContentViewPreview: View {
        @State var transcriptions = [Transcription(
            title: "My First Transcription",
            createdAt: Date.now,
            executionTime: ExecutionTime(
                startup: 4.1, audioProcessing: 1.0, transcription: 128
            ),
            segments: [
                IdentifiableSegment(startTime: 1, endTime: 1, text: "Some transcription started"),
                IdentifiableSegment(startTime: 1, endTime: 1, text: "and kept going"),
                IdentifiableSegment(startTime: 1, endTime: 1, text: "for awhile")
            ]
        )]
        
        var body: some View {
            ContentView(transcriptions: $transcriptions)
        }
    }
    
    return ContentViewPreview()
}
