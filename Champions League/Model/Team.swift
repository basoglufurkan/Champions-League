//
//  Team.swift
//  Champions League
//
//  Created by Furkan BAŞOĞLU on 30.06.2024.
//

import Foundation

struct Team: Identifiable {
    let id = UUID()
    let name: String
    var strength: Int
    var points: Int = 0
    var wins: Int = 0
    var draws: Int = 0
    var losses: Int = 0
    var goalsFor: Int = 0
    var goalsAgainst: Int = 0
    
    var goalDifference: Int {
        return goalsFor - goalsAgainst
    }
}

