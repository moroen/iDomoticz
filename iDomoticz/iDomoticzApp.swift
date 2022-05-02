//
//  iDomoticzApp.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 16/04/2022.
//

import SwiftUI

@main
struct iDomoticzApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

