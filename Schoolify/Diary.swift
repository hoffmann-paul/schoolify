//
//  Diary.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 17.05.26.
//

import SwiftUI

struct Diary: View {
    
    @AppStorage("diaryEntries") private var entriesData: String = "[]"
    @State private var deleteDiaryAlert = false
    @State private var diaryToDelete: DiaryEntry? = nil

       
    var entries: [DiaryEntry] {
        guard let data = entriesData.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([DiaryEntry].self, from: data)
        else { return [] }
        return decoded.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        
// MARK: - body
        NavigationStack() {
            VStack() {
                NavigationLink(destination: newDiary()) {
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.accentColor)
                            .frame(height: 50)
                        
                        Text("Neuer Eintrag")
                            .font(.system(size: 20))
                            .bold()
                            .foregroundStyle(Color.white)
                    }
                }
                .padding()
                
                List(entries) { entry in
                    HStack() {
                        VStack(alignment: .leading) {
                            Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            HStack {
                                Text("⭐ \(entry.stars)/5 ")
                                Text("🎓 \(entry.caps)/5")
                            }
                            if !entry.comment.isEmpty {
                                Text(entry.comment)
                                    .lineLimit(4)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                            .onTapGesture { requestDeleteDiary(diary: entry) }
                            .padding()
                            .glassEffect()
                    }
                }
                .alert("Eintrag löschen?", isPresented: $deleteDiaryAlert) {
                    Button("Löschen", role: .destructive) {
                        deleteDiary()
                    }
                    Button("Abbrechen", role: .cancel) {
                        diaryToDelete = nil
                    }
                } message: {
                    Text("Möchtest du diesen Eintrag wirklich löschen?")
                }

                Spacer()
            }
        }
        .padding()
    }
    
// MARK: - func
    
    func deleteDiary() {
        // 1. Aktuellen JSON-String laden und dekodieren
        guard let data = entriesData.data(using: .utf8),
              var allEntries = try? JSONDecoder().decode([DiaryEntry].self, from: data)
        else { return }
        
        // 2. Eintrag anhand der ID entfernen
        allEntries.removeAll { $0.id == diaryToDelete?.id }
        
        // 3. Aktualisiertes Array wieder als JSON speichern
        if let encoded = try? JSONEncoder().encode(allEntries),
           let jsonString = String(data: encoded, encoding: .utf8) {
            entriesData = jsonString
        }
        
        diaryToDelete = nil
    }
    
    func requestDeleteDiary(diary: DiaryEntry) {
        deleteDiaryAlert = true
        diaryToDelete = diary
    }
}

#Preview {
    Diary()
}
