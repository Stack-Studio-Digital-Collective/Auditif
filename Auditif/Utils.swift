//
//  Utils.swift
//  Auditif
//
//  Created by Kevin Diem on 7/28/24.
//

import Foundation
import SwiftUI

func downloadFile(transcription: Transcription) {
    let panel = NSSavePanel()
    
    panel.allowedContentTypes = [.plainText]
    panel.nameFieldStringValue = "\(transcription.title).txt"
    
    if panel.runModal() == .OK, let url = panel.url {
        let fileManager = FileManager()
        
        let transcription = transcription.segments.map(\.text).joined(separator: "\n")
        
        let data = Data(transcription.utf8)
        
        fileManager.createFile(atPath: url.path, contents: data)
    }
}
