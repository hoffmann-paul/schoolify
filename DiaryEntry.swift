//
//  DiaryEntry.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 17.05.26.
//

import SwiftUI

struct DiaryEntry: Codable, Identifiable {
    var id: UUID = UUID()
    var date: Date = Date()
    var stars: Int
    var caps: Int
    var comment: String
}
