//
//  EditMatchView.swift
//  Champions League
//
//  Created by Furkan BAŞOĞLU on 1.07.2024.
//

import SwiftUI

struct EditMatchView: View {
    @ObservedObject var league: LeagueViewModel
    @Environment(\.presentationMode) var presentationMode // For dismissing the view
    @State private var selectedWeek: Int = 0
    @State private var selectedMatchIndex: Int = 0
    @State private var team1Goals: String = ""
    @State private var team2Goals: String = ""

    var body: some View {
        VStack {
            Picker("Select Week", selection: $selectedWeek) {
                ForEach(0..<league.matches.count, id: \.self) { week in
                    Text("Week \(week + 1)").tag(week)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Picker("Select Match", selection: $selectedMatchIndex) {
                ForEach(0..<league.matches[selectedWeek].count, id: \.self) { index in
                    let match = league.matches[selectedWeek][index]
                    Text("\(match.0.name) vs \(match.1.name)").tag(index)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            HStack {
                TextField("Team 1 Goals", text: $team1Goals)
                    .keyboardType(.numberPad)
                    .padding()
                    .border(Color.gray)
                TextField("Team 2 Goals", text: $team2Goals)
                    .keyboardType(.numberPad)
                    .padding()
                    .border(Color.gray)
            }

            Button("Update") {
                if let team1GoalsInt = Int(team1Goals),
                   let team2GoalsInt = Int(team2Goals) {
                    league.editMatchResult(week: selectedWeek, matchIndex: selectedMatchIndex, team1Goals: team1GoalsInt, team2Goals: team2GoalsInt)
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
                }
            }
            .padding()
        }
        .navigationTitle("Edit Match Result")
    }
}
