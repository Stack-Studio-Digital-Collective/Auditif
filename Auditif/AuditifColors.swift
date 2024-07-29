//
//  Colors.swift
//  Auditif
//
//  Created by Kevin Diem on 7/28/24.
//

import Foundation
import SwiftUI

// WIP Color scheme

struct AuditifColors {
    static func sidebarBackgroundColor(for colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color.darkSidebarBackground : Color.lightSidebarBackground
    }
    
    static func mainContentBackgroundColor(for colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color.darkMainContentBackground : Color.lightMainContentBackground
    }
    
    static func textColor(for colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color.darkText : Color.lightText
    }
    
    static func gradientColors() -> [Color] {
        return [Color.pink, Color.orange, Color.blue, Color.purple]
    }
}

extension Color {
    static let lightSidebarBackground = Color(red: 0.95, green: 0.95, blue: 0.95) // Light Grey
    static let darkSidebarBackground = Color(red: 0.15, green: 0.15, blue: 0.15) // Darker Gray
    static let lightMainContentBackground = Color(red: 1.0, green: 1.0, blue: 1.0) // White
    static let darkMainContentBackground = Color(red: 0.1, green: 0.1, blue: 0.1) // Dark Gray
    static let lightText = Color(red: 0.2, green: 0.2, blue: 0.2) // Dark Text
    static let darkText = Color(red: 0.9, green: 0.9, blue: 0.9) // Light Text
    
    static let pink = Color(red: 1.0, green: 0.36, blue: 0.63)
    static let orange = Color(red: 1.0, green: 0.72, blue: 0.24)
    static let blue = Color(red: 0.0, green: 0.52, blue: 1.0)
    static let purple = Color(red: 0.48, green: 0.0, blue: 1.0)
}
