//
//  RunningTime.swift
//  SyncTime
//
//  Created by Nicho on 04/10/2024.
//

import SwiftUI
import WeHaveTime

struct RunningTime: View {
    
    let time: TimeEntry
    @State private var elapsedTime: TimeInterval
    let timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
    init(time: TimeEntry) {
        self.time = time
        let initialElapsedTime = Date().timeIntervalSince(time.startDate ?? Date.now)
        _elapsedTime = State(initialValue: initialElapsedTime)
    }
    
    var body: some View {
        Text(timeString(interval: elapsedTime))
            .font(.body)
            .monospaced()
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.mint)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onReceive(timer) { _ in
                elapsedTime = Date().timeIntervalSince(time.startDate ?? Date.now)
            }
    }
    
    func timeString(interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = Int(interval) / 60 % 60
        let seconds = Int(interval) % 60
        let milliseconds = Int((interval - floor(interval)) * 1000)
        return String(format: "%02ih%02imn%02is%03i", hours, minutes, seconds, milliseconds)
    }
}
