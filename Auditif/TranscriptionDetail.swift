//
//  TranscriptionDetail.swift
//  Auditif
//
//  Created by Kevin Diem on 7/28/24.
//

import Foundation
import SwiftUI

struct TranscriptionDetail: View {
    @Binding var transcription: Transcription
    @State var showingDeleteDialog = false
    private let remove: () -> Void
    private let dateFormatter: DateFormatter
    
    init(
        transcription: Binding<Transcription>,
        remove: @escaping () -> Void
    ) {
        self._transcription = transcription
        self.remove = remove
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .medium
    }
    
    var body: some View {
        VStack {
            HStack(
                alignment: .top
            ) {
                VStack(
                    alignment: .leading
                ) {
                    TextField("Transcription Name", text:$transcription.title)
                    Text("Created \(dateFormatter.string(from: transcription.createdAt))")
                }
                Spacer()
                Image(systemName: "square.and.arrow.down")
                    .renderingMode(.template)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        downloadFile(transcription: transcription)
                    }
                    
                Image(systemName: "trash")
                    .renderingMode(.template)
                    .foregroundColor(.red)
                    .onTapGesture {
                        showingDeleteDialog = true
                    }
                    .confirmationDialog("Delete transcript?", isPresented: $showingDeleteDialog) {
                        Button("Delete", role: .destructive) {
                            remove()
                            showingDeleteDialog = false
                        }
                        Button("Cancel", role: .cancel) {
                            showingDeleteDialog = false
                        }
                    }
                
            }
            .padding()
            
            List {
                ForEach(transcription.segments) { segment in
                    Text(segment.text)
                }
            }
        }
        .padding()
    }
}

#Preview {
    struct TranscriptionDetailPreview: View {
        @State var transcription = Transcription(
            title: "My First Transcription",
            createdAt: Date.now,
            segments: [
                IdentifiableSegment(startTime: 1, endTime: 1, text: "Some transcription started"),
                IdentifiableSegment(startTime: 1, endTime: 1, text: "and kept going"),
                IdentifiableSegment(startTime: 1, endTime: 1, text: "for awhile")
            ]
        )
        
        var body: some View {
            TranscriptionDetail(
                transcription: $transcription,
                remove: {}
            )
        }
    }
    
    
    return TranscriptionDetailPreview()
}
