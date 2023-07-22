//
//  YouBikeTestApp.swift
//  YouBikeTest
//
//  Created by Jhen Mu on 2023/7/21.
//

import SwiftUI

@main
struct YouBikeTestApp: App {
    
    @State var searchText: String = "Initail Text"
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(searchText: $searchText)
            }
        }
    }
}
