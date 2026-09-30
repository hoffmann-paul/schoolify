//
//  VocabelEntry.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 18.05.26.
//

import SwiftUI

struct VocabelEntry: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var german: String
    var otherLang: String
}
