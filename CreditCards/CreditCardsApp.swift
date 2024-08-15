//
//  CreditCardsApp.swift
//  CreditCards
//
//  Created by Alondra García Morales on 06/08/24.
//

import SwiftUI

@main
struct CreditCardsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
