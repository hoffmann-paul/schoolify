//
//  learnPlan.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 25.05.26.
//

import SwiftUI

struct learnPlan: View {
    
    @AppStorage("learnPlans") private var entriesData: String = "[]"
    @State private var learnPlans: [LearnPlanEntry] = []
    
    var body: some View {
        NavigationStack() {
            VStack() {
                NavigationLink(destination: createLearnPlan()) {
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.accentColor)
                            .frame(height: 50)
                        
                        Text("Neuer Lernplan")
                            .font(.system(size: 20))
                            .bold()
                            .foregroundStyle(Color.white)
                    }
                }
                .padding()
                
                List() {
                    ForEach($learnPlans) { $plan in
                        NavigationLink(destination: learnPlanDetail(plan: $plan, onDelete: {
                            learnPlans.removeAll { $0.id == plan.id } }
                            )) {
                            VStack() {
                                HStack() {
                                    Text(plan.name)
                                        .bold()
                                    
                                    Spacer()
                                    
                                    Text("\(plan.days) Tage")
                                }
                                
                                Divider()
                                
                                ForEach(plan.themes) { theme in
                                    HStack() {
                                        Text(theme.name)
                                        
                                        if theme.quantity == 0 {
                                            Image(systemName: "circle.fill")
                                                .foregroundStyle(Color.green)
                                        } else {
                                            if theme.quantity == 1 {
                                                Image(systemName: "circle.fill")
                                                    .foregroundStyle(Color.yellow)
                                            } else {
                                                if theme.quantity == 2 {
                                                    Image(systemName: "circle.fill")
                                                        .foregroundStyle(Color.red)
                                                }
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        if theme.done {
                                            if theme.state == 0 {
                                                Text("Schlecht")
                                                    .foregroundStyle(Color.red)
                                            } else {
                                                if theme.state == 1 {
                                                    Text("Mittel")
                                                        .foregroundStyle(Color.yellow)
                                                } else {
                                                    if theme.state == 2 {
                                                        Text("Gut")
                                                            .foregroundStyle(Color.green)
                                                    }
                                                }
                                            }
                                        } else {
                                            Text("Nicht gelernt")
                                                .foregroundStyle(Color.red)
                                        }
                                    }
                                    }
                                }
                        }
                    }
                }
                .onAppear(perform: loadLearnPlans )
                .onChange(of: learnPlans) {
                    saveLearnPlans()
                }
                
                Spacer()
            }
        }
    }
    
    func loadLearnPlans() {
        if let data = entriesData.data(using: .utf8) {
            let decoder = JSONDecoder()
            learnPlans = (try? decoder.decode([LearnPlanEntry].self, from: data)) ?? []
        }
    }
    
    func saveLearnPlans() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(learnPlans),
           let string = String(data: data, encoding: .utf8) {
            entriesData = string
        }
    }
    
}

#Preview {
    learnPlan()
}
