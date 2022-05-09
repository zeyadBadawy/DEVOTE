//
//  DEVOTEApp.swift
//  DEVOTE
//
//  Created by Zeyad Badawy on 09/05/2022.
//

import SwiftUI

@main
struct DEVOTEApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
