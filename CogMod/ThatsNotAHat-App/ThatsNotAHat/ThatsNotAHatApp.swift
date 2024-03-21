//
//  ThatsNotAHatApp.swift
//  ThatsNotAHat
//
//  Created by UsabilityLab on 2/21/24.
//

import SwiftUI


@main
struct ThatsNotAHatApp: App {
    @StateObject var game = ThatsNotAHatGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
