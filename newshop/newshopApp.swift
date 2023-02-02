//
//  newshopApp.swift
//  newshop
//
//  Created by Pradeep Banavara on 02/02/23.
//

import SwiftUI

@main
struct newshopApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
