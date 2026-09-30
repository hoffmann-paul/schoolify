//
//  newDiary.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 17.05.26.
//

import SwiftUI

struct newDiary: View {
    
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("diaryEntries") private var entriesData: String = "[]"
    
    @State private var starOne = false
    @State private var starTwo = false
    @State private var starThree = false
    @State private var starFour = false
    @State private var starFive = false
    
    @State private var filledStars: Int = 0
    
    @State private var capOne = false
    @State private var capTwo = false
    @State private var capThree = false
    @State private var capFour = false
    @State private var capFive = false
    
    @State private var filledCaps: Int = 0
    
    @State private var comment: String = ""
    
    @State private var submitAlert = false
    
    var body: some View {
        VStack() {
            
// MARK: - Sterne
            HStack() {
                Text("Gestaltung:")
                    .bold()
                
                Spacer()
                
                if starOne {
                    Image(systemName: "star.fill")
                        .onTapGesture { fillStars(Int: 0) }
                } else {
                    Image(systemName: "star")
                        .onTapGesture { fillStars(Int: 0) }
                }
                
                if starTwo {
                    Image(systemName: "star.fill")
                        .onTapGesture { fillStars(Int: 1) }
                } else {
                    Image(systemName: "star")
                        .onTapGesture { fillStars(Int: 1) }
                }
                
                if starThree {
                    Image(systemName: "star.fill")
                        .onTapGesture { fillStars(Int: 2) }
                } else {
                    Image(systemName: "star")
                        .onTapGesture { fillStars(Int: 2) }
                }
                
                if starFour {
                    Image(systemName: "star.fill")
                        .onTapGesture { fillStars(Int: 3) }
                } else {
                    Image(systemName: "star")
                        .onTapGesture { fillStars(Int: 3) }
                }
                
                if starFive {
                    Image(systemName: "star.fill")
                        .onTapGesture { fillStars(Int: 4) }
                } else {
                    Image(systemName: "star")
                        .onTapGesture { fillStars(Int: 4) }
                }
            }
            .font(.system(size: 25))

            Divider()
            
// MARK: - Hüte
            HStack() {
                Text("Inhalt:")
                    .bold()
                
                Spacer()
                
                if capOne {
                    Image(systemName: "graduationcap.fill")
                        .onTapGesture { fillCaps(Int: 0) }
                } else {
                    Image(systemName: "graduationcap")
                        .onTapGesture { fillCaps(Int: 0) }
                }
                
                if capTwo {
                    Image(systemName: "graduationcap.fill")
                        .onTapGesture { fillCaps(Int: 1) }
                } else {
                    Image(systemName: "graduationcap")
                        .onTapGesture { fillCaps(Int: 1) }
                }
                
                if capThree {
                    Image(systemName: "graduationcap.fill")
                        .onTapGesture { fillCaps(Int: 2) }
                } else {
                    Image(systemName: "graduationcap")
                        .onTapGesture { fillCaps(Int: 2) }
                }
                
                if capFour {
                    Image(systemName: "graduationcap.fill")
                        .onTapGesture { fillCaps(Int: 3) }
                } else {
                    Image(systemName: "graduationcap")
                        .onTapGesture { fillCaps(Int: 3) }
                }
                
                if capFive {
                    Image(systemName: "graduationcap.fill")
                        .onTapGesture { fillCaps(Int: 4) }
                } else {
                    Image(systemName: "graduationcap")
                        .onTapGesture { fillCaps(Int: 4) }
                }
            }
            .font(.system(size: 25))
            
// MARK: - Kommentar
            
            Divider()
            
            TextEditor(text: $comment)
                .overlay() {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.primary, lineWidth: 1)
                }
            
            Divider()
            
//MARK: - Button
            
            ZStack() {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 50)
                    .foregroundStyle(Color.accentColor)
                
                Text("Bewerten")
                    .font(.system(size: 20))
                    .bold()
            }
            .onTapGesture { submitDiary() }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Neuer Eintrag")
        .alert("Eintrag wurde erstellt", isPresented: $submitAlert) {
    
            Button("Ok", role: .cancel) {
                dismiss()
            }
        }
    }
    
// MARK: - func
    
    func fillStars(Int tappedStar: Int) {
        if tappedStar >= 0 {
            starOne = true
        } else {
            starOne = false
        }
        
        if tappedStar >= 1 {
            starTwo = true
        } else {
            starTwo = false
        }
        
        if tappedStar >= 2 {
            starThree = true
        } else {
            starThree = false
        }
        
        if tappedStar >= 3 {
            starFour = true
        } else {
            starFour = false
        }
        
        if tappedStar >= 4 {
            starFive = true
        } else {
            starFive = false
        }
        
        filledStars = Int(tappedStar) + 1
        
    }
    
    func fillCaps(Int tappedCap: Int) {
        if tappedCap >= 0 {
            capOne = true
        } else {
            capOne = false
        }
        
        if tappedCap >= 1 {
            capTwo = true
        } else {
            capTwo = false
        }
        
        if tappedCap >= 2 {
            capThree = true
        } else {
            capThree = false
        }
        
        if tappedCap >= 3 {
            capFour = true
        } else {
            capFour = false
        }
        
        if tappedCap >= 4 {
            capFive = true
        } else {
            capFive = false
        }
        
        filledCaps = Int(tappedCap) + 1
        
    }
    
    func submitDiary() {
        // 1. Neuen Eintrag erstellen
        let newEntry = DiaryEntry(
            stars: filledStars,
            caps: filledCaps,
            comment: comment
        )

        // 2. Bisherige Einträge aus AppStorage laden und dekodieren
        var allEntries: [DiaryEntry] = []

        if let data = entriesData.data(using: .utf8) {
            let decoder = JSONDecoder()
            allEntries = (try? decoder.decode([DiaryEntry].self, from: data)) ?? []
        }

        // 3. Neuen Eintrag anhängen
        allEntries.append(newEntry)

        // 4. Alles wieder als JSON-String speichern
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allEntries),
           let jsonString = String(data: encoded, encoding: .utf8) {
            entriesData = jsonString   // → wird automatisch in UserDefaults gespeichert
        }
        
        submitAlert = true
        
    }
}

#Preview {
    newDiary()
}
