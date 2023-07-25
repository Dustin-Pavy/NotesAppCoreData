//
//  NotesAppApp.swift
//  NotesApp
//
//  Created by Consultant on 7/25/23.
//

import SwiftUI

@main
struct NotesAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
