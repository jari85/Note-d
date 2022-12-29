//
//  Note_dApp.swift
//  Note'd
//
//  Created by Ariel on 12/24/22.
//

import SwiftUI
import FirebaseCore

@main
struct Note_dApp: App {
    let persistenceController = PersistenceController.shared
    init() { FirebaseApp.configure() }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}

extension NSTextField{
    open override var focusRingType: NSFocusRingType{
        get{.none}
        set{}
    }
}
