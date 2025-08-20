//
//  MistakeMasterApp.swift
//  MistakeMaster
//
//  Created by Ben Scaife on 5/28/25 for MistakeMaster.
//

import SwiftUI

@main
struct MistakeMasterApp: App {
    @StateObject private var store = Store.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
