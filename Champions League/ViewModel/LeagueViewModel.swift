//
//  LeagueViewModel.swift
//  Champions League
//
//  Created by Furkan BAŞOĞLU on 30.06.2024.
//

import Foundation

class LeagueViewModel: ObservableObject {
    @Published var teams: [Team]
    @Published var matches: [[(Team, Team, Int, Int)]] = []
    @Published var weeklyMatchups: [(Team, Team)] = []
    @Published var weeklyMatches: [(Team, Team, Int, Int)] = []
    var week = 0
    
    init() {
        self.teams = LeagueViewModel.generateTeams()
        self.weeklyMatchups = generateWeeklyMatchups()
    }
    
    static func generateTeams() -> [Team] {
        return [
            Team(name: "Arsenal", strength: 8),
            Team(name: "Aston Villa", strength: 6),
            Team(name: "Bournemouth", strength: 5),
            Team(name: "Brentford", strength: 6),
            Team(name: "Brighton and Hove Albion", strength: 7),
            Team(name: "Chelsea", strength: 8),
            Team(name: "Crystal Palace", strength: 6),
            Team(name: "Everton", strength: 6),
            Team(name: "Fulham", strength: 6),
            Team(name: "Ipswich Town", strength: 4),
            Team(name: "Leicester City", strength: 6),
            Team(name: "Liverpool", strength: 9),
            Team(name: "Manchester City", strength: 10),
            Team(name: "Manchester United", strength: 8),
            Team(name: "Newcastle United", strength: 8),
            Team(name: "Nottingham Forest", strength: 5),
            Team(name: "Southampton", strength: 5),
            Team(name: "Tottenham Hotspur", strength: 7),
            Team(name: "West Ham United", strength: 6),
            Team(name: "Wolverhampton Wanderers", strength: 6)
        ]
    }
    
    func playMatch(team1: inout Team, team2: inout Team) {
        let team1Goals = predictGoals(for: team1)
        let team2Goals = predictGoals(for: team2)
        weeklyMatches.append((team1, team2, team1Goals, team2Goals))
        
        team1.goalsFor += team1Goals
        team1.goalsAgainst += team2Goals
        team2.goalsFor += team2Goals
        team2.goalsAgainst += team1Goals
        
        if team1Goals > team2Goals {
            team1.points += 3
            team1.wins += 1
            team2.losses += 1
        } else if team2Goals > team1Goals {
            team2.points += 3
            team2.wins += 1
            team1.losses += 1
        } else {
            team1.points += 1
            team2.points += 1
            team1.draws += 1
            team2.draws += 1
        }
    }
    
    func playWeeklyMatches() {
        weeklyMatches.removeAll()
        
        for (team1, team2) in weeklyMatchups {
            var team1 = teams.first { $0.id == team1.id }!
            var team2 = teams.first { $0.id == team2.id }!
            playMatch(team1: &team1, team2: &team2)
            updateTeam(team: team1)
            updateTeam(team: team2)
        }
        
        matches.append(weeklyMatches)
        week += 1
        weeklyMatchups = generateWeeklyMatchups()
    }
    
    func playAllMatches() {
        while week < 38 {
            playWeeklyMatches()
        }
    }
    
    func editMatchResult(week: Int, matchIndex: Int, team1Goals: Int, team2Goals: Int) {
        guard week < matches.count else { return }
        guard matchIndex < matches[week].count else { return }
        
        var match = matches[week][matchIndex]
        let (team1, team2, oldTeam1Goals, oldTeam2Goals) = match
        
        guard let team1Index = teams.firstIndex(where: { $0.id == team1.id }),
              let team2Index = teams.firstIndex(where: { $0.id == team2.id }) else {
            return
        }
        
        updateTeamStats(team: &teams[team1Index], goalsFor: -oldTeam1Goals, goalsAgainst: -oldTeam2Goals, points: pointsDifference(oldGoals: oldTeam1Goals, newGoals: oldTeam2Goals))
        updateTeamStats(team: &teams[team2Index], goalsFor: -oldTeam2Goals, goalsAgainst: -oldTeam1Goals, points: pointsDifference(oldGoals: oldTeam2Goals, newGoals: oldTeam1Goals))
        
        match.2 = team1Goals
        match.3 = team2Goals
        matches[week][matchIndex] = match
        updateTeamStats(team: &teams[team1Index], goalsFor: team1Goals, goalsAgainst: team2Goals, points: pointsDifference(oldGoals: team2Goals, newGoals: team1Goals))
        updateTeamStats(team: &teams[team2Index], goalsFor: team2Goals, goalsAgainst: team1Goals, points: pointsDifference(oldGoals: team1Goals, newGoals: team2Goals))
    }
    
    // gollere göre puan farkını hesaplar
    private func pointsDifference(oldGoals: Int, newGoals: Int) -> Int {
        if oldGoals > newGoals {
            return -3
        } else if oldGoals < newGoals {
            return 3
        } else {
            return 0
        }
    }
    
    private func updateTeamStats(team: inout Team, goalsFor: Int, goalsAgainst: Int, points: Int) {
        team.goalsFor += goalsFor
        team.goalsAgainst += goalsAgainst
        team.points += points
    }
    
    private func generateWeeklyMatchups() -> [(Team, Team)] {
        let numberOfTeams = teams.count
        var indices = Array(0..<numberOfTeams)
        indices.shuffle()
        
        var matchups: [(Team, Team)] = []
        for i in stride(from: 0, to: 8, by: 2) { // Only 4 matches for 8 teams
            if i + 1 < numberOfTeams {
                let team1 = teams[indices[i]]
                let team2 = teams[indices[i + 1]]
                matchups.append((team1, team2))
            }
        }
        return matchups
    }
    
    //sorts the teams based on points
    func sortedTeams() -> [Team] {
        return teams.sorted { $0.points > $1.points }
    }
    
    private func updateTeam(team: Team) {
        if let index = teams.firstIndex(where: { $0.id == team.id }) {
            teams[index] = team
        }
    }
    
    private func predictGoals(for team: Team) -> Int {
        return Int.random(in: 0...(team.strength * 2))
    }
    
    //calculates the championship predictions based on the teams’ points
    func championshipPredictions() -> [(Team, Double)] {
        let totalPoints = teams.reduce(0) { $0 + $1.points }
        return teams.map { ($0, Double($0.points) / Double(totalPoints) * 100) }
            .sorted { $0.1 > $1.1 }
    }
    
    //resets the league
    func resetLeague() {
        self.teams = LeagueViewModel.generateTeams()
        self.matches.removeAll()
        self.weeklyMatchups = generateWeeklyMatchups()
        self.weeklyMatches.removeAll()
        self.week = 0
    }
    
    func updateLeagueState(for week: Int) {
        self.teams = LeagueViewModel.generateTeams()
            for i in 0..<week {
            let weekMatches = matches[i]
            for match in weekMatches {
                guard let team1Index = teams.firstIndex(where: { $0.id == match.0.id }),
                      let team2Index = teams.firstIndex(where: { $0.id == match.1.id }) else {
                    continue
                }
                
                var team1 = teams[team1Index]
                var team2 = teams[team2Index]
                let team1Goals = match.2
                let team2Goals = match.3
                
                team1.goalsFor += team1Goals
                team1.goalsAgainst += team2Goals
                team2.goalsFor += team2Goals
                team2.goalsAgainst += team1Goals
                
                if team1Goals > team2Goals {
                    team1.points += 3
                    team1.wins += 1
                    team2.losses += 1
                } else if team2Goals > team1Goals {
                    team2.points += 3
                    team2.wins += 1
                    team1.losses += 1
                } else {
                    team1.points += 1
                    team2.points += 1
                    team1.draws += 1
                    team2.draws += 1
                }
                
                teams[team1Index] = team1
                teams[team2Index] = team2
            }
        }
        if week < 38 {
            self.weeklyMatchups = generateWeeklyMatchups()
        }
    }
}
