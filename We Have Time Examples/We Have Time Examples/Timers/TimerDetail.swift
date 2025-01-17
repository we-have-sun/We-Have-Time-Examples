//
//  TimerDetail.swift
//  SyncTime
//
//  Created by Nicho on 02/10/2024.
//

import SwiftUI
import WeHaveTime

struct TimerDetail: View {
    var time: TimeEntry
    var body: some View {
        VStack{
            Text("Time Duration:")
                .font(.title)
            Text(time.name)
                .font(.headline)
            Text("\(time.duration)")
                .font(.caption)
        }
        
    }
}

