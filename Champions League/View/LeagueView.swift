//
//  LeagueView.swift
//  Champions League
//
//  Created by Furkan BAŞOĞLU on 30.06.2024.
//

import SwiftUI

struct LeagueView: View {
    @StateObject private var league = LeagueViewModel()
    @State private var selectedWeek: Int = 0
    @State private var showEditMatchView = false
    
    var body: some View {
        NavigationView {
            VStack {
                if league.week > 0 && league.week < 38 {
                    Picker("Select Week", selection: $selectedWeek) {
                        ForEach(0..<league.week, id: \.self) { week in
                            Text("Week \(week + 1)").tag(week)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                }
                
                List {
                    Section(header: Text("Upcoming Matches")) {
                        ForEach(league.weeklyMatchups, id: \.0.id) { matchup in
                            HStack {
                                Text(matchup.0.name)
                                    .fontWeight(.bold)
                                    .frame(width: 120, alignment: .leading)
                                Spacer()
                                Text("vs")
                                    .frame(width: 20, alignment: .center)
                                Spacer()
                                Text(matchup.1.name)
                                    .fontWeight(.bold)
                                    .frame(width: 120, alignment: .trailing)
                            }
                        }
                    }
                    
                    Section(header: Text("Match Results")) {
                        if selectedWeek < league.matches.count {
                            Text("\(selectedWeek + 1). Week Match Results")
                                .fontWeight(.bold)
                                .padding(.bottom, 4)
                            
                            ForEach(league.matches[selectedWeek], id: \.0.id) { match in
                                HStack {
                                    Text(match.0.name)
                                        .fontWeight(.bold)
                                        .frame(width: 120, alignment: .leading)
                                    Spacer()
                                    Text("\(match.2) - \(match.3)")
                                        .frame(width: 50, alignment: .center)
                                    Spacer()
                                    Text(match.1.name)
                                        .fontWeight(.bold)
                                        .frame(width: 120, alignment: .trailing)
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("League Table")) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Team")
                                    .fontWeight(.bold)
                                    .frame(width: 120, alignment: .leading)
                                Spacer()
                                Text("PTS")
                                    .fontWeight(.bold)
                                    .frame(width: 40, alignment: .trailing)
                                Text("W")
                                    .fontWeight(.bold)
                                    .frame(width: 30, alignment: .trailing)
                                Text("D")
                                    .fontWeight(.bold)
                                    .frame(width: 30, alignment: .trailing)
                                Text("L")
                                    .fontWeight(.bold)
                                    .frame(width: 30, alignment: .trailing)
                                Text("GD")
                                    .fontWeight(.bold)
                                    .frame(width: 40, alignment: .trailing)
                            }
                            .padding([.top, .bottom], 4)
                            
                            ForEach(league.sortedTeams()) { team in
                                Divider()
                                HStack {
                                    Text(team.name)
                                        .fontWeight(.bold)
                                        .frame(width: 120, alignment: .leading)
                                    Spacer()
                                    Text("\(team.points)")
                                        .frame(width: 40, alignment: .trailing)
                                    Text("\(team.wins)")
                                        .frame(width: 30, alignment: .trailing)
                                    Text("\(team.draws)")
                                        .frame(width: 30, alignment: .trailing)
                                    Text("\(team.losses)")
                                        .frame(width: 30, alignment: .trailing)
                                    Text("\(team.goalDifference)")
                                        .frame(width: 40, alignment: .trailing)
                                }
                            }
                        }
                    }
                    
                    if league.week >= 1 {
                        Section(header: Text("Championship Predictions")) {
                            ForEach(league.championshipPredictions(), id: \.0.id) { prediction in
                                HStack {
                                    Text(prediction.0.name)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text(String(format: "%.1f%%", prediction.1))
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    if league.week < 38 {
                        Button("Play All") {
                            league.playAllMatches()
                            selectedWeek = league.matches.count - 1
                        }
                        .padding()
                        
                        Button("Next Week") {
                            league.playWeeklyMatches()
                            selectedWeek = league.matches.count - 1
                        }
                        .padding()
                    } else {
                        Button("Play Again") {
                            league.resetLeague()
                            selectedWeek = 0
                        }
                        .padding()
                    }
                    
                    Button("Edit Match Result") {
                        showEditMatchView.toggle()
                    }
                    .padding()
                    .sheet(isPresented: $showEditMatchView) {
                        EditMatchView(league: league)
                    }
                }
            }
            .navigationTitle("Champions League")
        }
    }
}

#Preview {
    LeagueView()
}
