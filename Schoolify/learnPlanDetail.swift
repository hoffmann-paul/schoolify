//
//  learnPlanDetail.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 25.05.26.
//

import SwiftUI

struct learnPlanDetail: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var plan: LearnPlanEntry
    @State private var showDeleteAlarm: Bool = false
    var onDelete: () -> Void
    
    var body: some View {
        VStack() {
            
            HStack() {
                VStack() {
                    Text("Tage zum lernen")
                        .bold()
                    
                    Text("\(plan.days)")
                }
                
                Divider()
                    .frame(width: 25, height: 50)
                
                VStack() {
                    Text("Themen")
                        .bold()
                    
                    Text("\(plan.themes.count)")
                }
            }
            
            Divider()
            
            Text("Themen:")
                .bold()
            
            List() {
                ForEach($plan.themes) { $theme in
                    NavigationLink(destination: themeDetail(theme: $theme)) {
                        VStack() {
                            HStack() {
                                Text(theme.name)
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            ZStack() {
                RoundedRectangle(cornerRadius: 22)
                    .fill(.background)
                    .frame(height: 50)
                    .glassEffect()
                
                HStack() {
                    
                    Image(systemName: "trash")
                        .foregroundStyle(Color.red)
                        .bold()
                    
                    Text("Lernplan Löschen")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundStyle(Color.red)
                }
            }
            .onTapGesture(perform: requestDeleteLearnPlan)
            
        }
        .alert("Lernplan löschen?", isPresented: $showDeleteAlarm) {
            Button("Löschen", role: .destructive) {
                confirmDelete()
            }
            Button("Abbrechen", role: .cancel) {
                
            }
        } message: {
            Text("Möchtest du diesen Lernplan wirklich löschen?")
        }
        .padding()
        .navigationTitle(plan.name)
    }
    
    func requestDeleteLearnPlan() {
        showDeleteAlarm = true
    }
    
    func confirmDelete() {
        onDelete()
        dismiss()
    }
}

#Preview {
    @Previewable @State var plan = LearnPlanEntry(
            name: "Mathe Prüfung",
            days: 5,
            themes: [
                ThemeEntry(name: "Algebra", quantity: 2, done: true, state: 1),
                ThemeEntry(name: "Geometrie", quantity: 0, done: false, state: 0)
            ]
        )
        
    NavigationStack {
        learnPlanDetail(plan: $plan, onDelete: {})
    }
}
