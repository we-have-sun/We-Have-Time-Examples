import SwiftUI
import WeHaveTime
import SwiftData

struct ProjectView: View {
        
    @Environment(\.modelContext) private var modelContext
    
    @Query(
        filter: #Predicate<TimeEntry> { timeEntry in
            timeEntry.parent == nil
        },
        sort: \TimeEntry.createdAt,
        order: .reverse
    ) var projects: [TimeEntry]

   
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                List {
                    ForEach(projects) {project in
                        NavigationLink(destination: EditProjectView(project: project)) {
                            ProjectRowView(project: project)
                        }
                    }
                    .onDelete(perform: deleteProject)
                }
            }
        .navigationTitle("Projects")
        .navigationDestination(for: TimeEntry.self) { project in
            EditProjectView(project: project)
        }
        .toolbar {
            Button("Add Project", systemImage: "plus") {
                let project = TimeEntry(name: "", createdAt: .now)
                modelContext.insert(project)
                do {
                    try modelContext.save()
                    navigationPath.append(project)
                } catch {
                    print(error)
                }
            }
            Button("Delete all", systemImage: "minus") {
                do {
                    try modelContext.delete(model: TimeEntry.self)
                    try modelContext.save()
                } catch {
                    print("Failed to clear "    )
                }
            }
        }
        }
    }
    
    func deleteProject(at indexSet: IndexSet) {
        for index in indexSet.sorted(by: >) {
            guard index < projects.count else { continue }
            modelContext.delete(projects[index])
        }
        do {
            try modelContext.save()
        } catch {
            print("Error saving context after deletion: \(error)")
        }
    }
    
    func timeString(interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = Int(interval) / 60 % 60
        let seconds = Int(interval) % 60
        let milliseconds = Int((interval - floor(interval)) * 1000)
        return String(format: "%02i:%02i:%02i:%03i", hours, minutes, seconds, milliseconds)
    }
}
