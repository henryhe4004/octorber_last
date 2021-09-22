//
//  HifamilySwiftUIApp.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/13.
//

import SwiftUI

@main
struct HifamilySwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
