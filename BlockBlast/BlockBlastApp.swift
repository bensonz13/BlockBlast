//
//  BlockBlastApp.swift
//  BlockBlast
//
//  Created by Student on 5/22/26.
//

import SwiftUI
import SwiftData

@main
struct BlockBlastApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: GameState.self)
    }
}
