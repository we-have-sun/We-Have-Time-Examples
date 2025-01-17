
#if canImport(ActivityKit)
import ActivityKit
#endif

import SwiftUI

#if os(iOS)
struct TimerAttributes: ActivityAttributes {
    public typealias TimerStatus = ContentState
    public struct ContentState: Codable, Hashable {
        var startTime: Date
        var projectName: String
    }
    
}
#endif
