//
//  ContentView.swift
//  We Have Time Examples
//
//  Created by Natalia Terlecka on 18/11/2024.
//

import SwiftUI
import WeHaveTime

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    var body: some View {
        ProjectView()
    }
}
