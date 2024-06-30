//
//  Champions_LeagueApp.swift
//  Champions League
//
//  Created by Furkan BAŞOĞLU on 30.06.2024.
//

import SwiftUI

@main
struct Champions_LeagueApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
