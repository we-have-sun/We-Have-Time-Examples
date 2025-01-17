
import SwiftUI
import SwiftData
import WeHaveTime

struct Timers: View {
    @Environment(\.modelContext) var modelContext
    @Query(
        filter: #Predicate<TimeEntry> { timeEntry in
            timeEntry.parent == nil
        },
        sort: \TimeEntry.createdAt,
        order: .reverse
    ) var projects: [TimeEntry]

    @StateObject private var navModel = NavigationModel()
    
    var body: some View {
        NavigationSplitView{
            List(projects, selection: $navModel.selectedProject) { project in
                NavigationLink(project.name, value:project)
            }
            .navigationTitle("Projects")
        } content: {
            List(navModel.selectedProject?.subentries ?? [], selection: $navModel.selectedTime) { time in
                NavigationLink(String(time.duration), value:time)
            }
            .navigationTitle(navModel.selectedProject?.name ?? "Times")
        } detail: {
            if navModel.selectedTime != nil {
                TimerDetail(time: navModel.selectedTime!)
            }
        }
    }
}
