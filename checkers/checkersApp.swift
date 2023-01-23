//
//  checkersApp.swift
//  checkers
//
//  Created by Damian Wiśniewski on 15/01/2023.
//

import SwiftUI

@main
struct checkersApp: App {
    var body: some Scene {
        WindowGroup {
            BoardView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
