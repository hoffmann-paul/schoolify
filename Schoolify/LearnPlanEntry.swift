//
//  LearnPlanEntry.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 25.05.26.
//

import SwiftUI

struct LearnPlanEntry: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    var days: Int
    var themes: [ThemeEntry]
}

struct ThemeEntry: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    var quantity: Int // Wie viel es zum lernen 0=Wenig 1=Mittel 2=Viel
    var done: Bool
    var state: Int // Wie gut man es Kann 0= Garnicht 1=Mittel 2= GUt
}
