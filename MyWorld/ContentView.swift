//
//  ContentView.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 28/9/2026.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "globe.asia.australia.fill")
                    .font(.system(size: 70))
                
                Text("MyWorld")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your travel history, all in one place.")
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("My World")
        }
    }
}

#Preview {
    ContentView()
}
