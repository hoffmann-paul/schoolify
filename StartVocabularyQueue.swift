//
//  StartVocabularyQueue.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 18.05.26.
//

import SwiftUI

struct StartVocabularyQueue: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var vocabulary: [VocabelEntry] = []
    
    @State private var possibleVocabulary: [VocabelEntry] = []
    @State private var queue: [VocabelEntry] = []
    
    @State private var correct = 0
    @State private var wrong = 0
    @State private var displayedGerman = ""
    @State private var displayedOtherLang = ""
    
    @State private var blurOtherLang = true
    @State private var blurGerman = false
    
    @State private var buttonsCanTapped = false
    
    @State private var showEndTrainingAlarm = false

//MARK: - body
    
    var body: some View {
        VStack() {
            HStack() {
                // Richtig anzeige
                ZStack() {
                    Circle()
                        .fill(Color.green)
                        .glassEffect()
                    
                    Text(String(correct))
                        .foregroundStyle(Color.black)
                        .bold()
                }
                .frame(width: 50, height: 50)
                
                Spacer()
                
                // Falsch anzeige
                ZStack() {
                    Circle()
                        .fill(Color.red)
                        .glassEffect()
                    
                    Text(String(wrong))
                        .foregroundStyle(Color.black)
                        .bold()
                }
                .frame(width: 50, height: 50)
            }
            // Deutsche Karte
            ZStack() {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.secondary)
                
                if blurGerman {
                    Text(displayedGerman)
                        .bold()
                        .font(.system(size: 35))
                        .blur(radius: 10)
                        .foregroundStyle(Color.black)
                } else {
                    Text(displayedGerman)
                        .bold()
                        .font(.system(size: 35))
                        .foregroundStyle(Color.black)
                }
            }
            .frame(height: 250)
            // reveal Button
            ZStack() {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.accentColor)
                
                Text("Aufdecken")
                    .bold()
                    .foregroundStyle(Color.black)
            }
            .frame(width: 400 ,height: 50)
            .padding()
            .onTapGesture { revealCards() }
            
            //fremdsprachen Karte
            ZStack() {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.secondary)
                
                if blurOtherLang {
                    Text(displayedOtherLang)
                        .bold()
                        .font(.system(size: 35))
                        .blur(radius: 10)
                        .foregroundStyle(Color.black)
                } else {
                    Text(displayedOtherLang)
                        .bold()
                        .font(.system(size: 35))
                        .foregroundStyle(Color.black)
                }
            }
            .frame(height: 250)
           // Gewusst/ Nicht Gewusst buttons
            HStack() {
                ZStack() {
                    if buttonsCanTapped {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.green)
                    } else {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                    }
                    
                    Text("Gewusst")
                        .bold()
                        .foregroundStyle(Color.black)
                }
                .frame(height: 50)
                .onTapGesture { buttons(Int: 1) }
                
                ZStack() {
                    if buttonsCanTapped {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.red)
                    } else {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                    }
                    
                    Text("Nicht Gewusst")
                        .bold()
                        .foregroundStyle(Color.black)
                }
                .frame(height: 50)
                .onTapGesture { buttons(Int: 0) }
            }
            .alert("Vokabeln zu ende", isPresented: $showEndTrainingAlarm) {
                Button("Ok", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("Weniger als 5 Vokablen mehr üprig du hast von \(correct) Vokabeln, bei \(wrong) Vokabeln Fehler gemacht")
            }
            
            Spacer()
        }
        .padding()
        .onAppear( perform: bootQueue )
    }
// MARK: - func
    
    func revealCards() {
        blurGerman = false
        blurOtherLang = false
        buttonsCanTapped = true
    }
    
    func buttons(Int sendingButton: Int) {
        if !buttonsCanTapped {
            return
        } else {
            if sendingButton == 1 {
                correct += 1
                
                queue.remove(at: 0)
                
                updateQueue()
            } else {
                wrong += 1
                
                let wrongVoc = queue[0]
                queue.remove(at: 0)
                
                queue = queue.compactMap { $0 }
                
                queue.append(wrongVoc)
                
                updateQueue()
            }
        }
    }
    
    func loadVocabulary() {
        let savedVocabulary = UserDefaults.standard.string(forKey: "vocabulary") ?? "[]"
        let data = Data(savedVocabulary.utf8)
        do {
            vocabulary = try JSONDecoder().decode([VocabelEntry].self, from: data)
        } catch {
            vocabulary = []
        }
    }
    
    func bootQueue() {
        
        correct = 0
        wrong = 0
        
        loadVocabulary()
        
        possibleVocabulary = vocabulary
        
        updateQueue()
    }
    
    func updateQueue() {
        queue = queue.compactMap { $0 }
        
        while queue.count < 5, let addedVoc = possibleVocabulary.randomElement() {
            queue.append(addedVoc)
            possibleVocabulary.removeAll { $0 == addedVoc }
            if possibleVocabulary.count == 0 {
                showEndTrainingAlarm = true
                return
            }
        }
        askVocabulary()
    }
    
    func askVocabulary() {
        buttonsCanTapped = false
        blurGerman = false
        
        displayedGerman = queue[0].german
        displayedOtherLang = queue[0].otherLang
        
        blurOtherLang = true
    }
}

#Preview {
    StartVocabularyQueue()
}
