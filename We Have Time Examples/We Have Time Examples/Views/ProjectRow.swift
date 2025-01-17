
#if canImport(ActivityKit)
import ActivityKit
#endif

import SwiftUI
import SwiftData
import WeHaveTime

@Observable
class ProjectModel {
    var project: TimeEntry
    init(project: TimeEntry) {
        self.project = project
    }
}

struct ProjectRowView: View {
    
    @Environment(\.modelContext) var modelContext
    @Bindable var project: TimeEntry
    
    
    //Live Activity
    @State private var isTrackingTime: Bool = false
    @State private var startTime: Date? = nil
    
#if os(iOS)
    @State private var activity: Activity<TimerAttributes>? = nil
#endif
    
    //TODO: Use a Predicate
    @Query private var times: [TimeEntry]
    private var timesByProjects: [TimeEntry] {
        times.filter { $0.parent?.id == project.id}
     }
    
    @State private var zeroDurationExists: Bool = false
    var body: some View {
        HStack(spacing: 16) {
            Group {
                if !project.hasRunningTimers {
                    Image(systemName: "play")
                        .onTapGesture {
                            addTime(to: project)
                            updateZeroDurationExists()
                            
                            #if os(iOS)
                            //TODO: end all Activities before starting this one
                            startLiveActivity(projectName: project.name, startTime: .now)
                            #endif
                            
                        }
                }
                if project.hasRunningTimers {
                    Image(systemName: "pause")
                    .onTapGesture {
                        calculateDurationAndPause(for: project)
                        updateZeroDurationExists()
                        
#if os(iOS)
                        endLiveActivity(projectName: project.name, startTime: .now)
#endif
                        
                    }
                }
                
            }
            
            VStack(alignment: .leading) {
                Text(project.name)
                    .font(.title2)
//                  .foregroundStyle(project.hasRunningTimers ? .red : .black)
                TimeDisplay(project: project)
                TimerTotalView(project: project)
            }
            
            }
        .onAppear{
            updateZeroDurationExists()
        }
        .onChange(of: times) {
            updateZeroDurationExists()
        }
    }

    func updateZeroDurationExists() {
        zeroDurationExists = timesByProjects.contains { $0.duration == 0 }
        }
    
    @MainActor
    func addTime(to project: TimeEntry) {
        let time = TimeEntry(name: "", duration: 0, startDate: .now, isRunning: true)
        project.subentries.append(time)
        time.parent = project
        
        do {
           try modelContext.save()
        } catch {
           print(error)
        }
        
    }
    func calculateDurationAndPause(for project: TimeEntry) {
        let times = timesByProjects
        if let zeroDurationTime = times.first(where: { $0.duration == 0 }) {
            if zeroDurationTime.startDate != nil {
                zeroDurationTime.duration = Int64(Date().timeIntervalSince(zeroDurationTime.startDate ?? Date.now))
                zeroDurationTime.endDate = Date.now
                
                
                zeroDurationTime.isRunning = false
                
                project.subentries.append(zeroDurationTime)
                zeroDurationTime.parent = project
                
                let temporaryTime = zeroDurationTime.copy() as! TimeEntry
                modelContext.delete(zeroDurationTime)
                project.subentries.append(temporaryTime)
                temporaryTime.parent = project
                
                do {
                   try modelContext.save()
                } catch {
                   print(error)
                }
            }
        }
        do {
           try modelContext.save()
            
        } catch {
           print(error)
        }
    }
    
#if os(iOS)
    func startLiveActivity(projectName: String = "", startTime: Date?) {
        let attributes = TimerAttributes()
        let state = TimerAttributes.ContentState(startTime: startTime ?? .now, projectName: projectName)
        do {
                activity = try Activity.request(
                    attributes: attributes,
                    content: .init(state: state, staleDate: nil)
                )
            } catch {
                print("Error starting Live Activity: \(error)")
            }
    }
    
    func endLiveActivity(projectName: String = "", startTime: Date?) {
        guard let startTime else { return }
        let state = TimerAttributes.ContentState(startTime: startTime, projectName: projectName)
        Task {
            await activity?.end(
                .init(state: state, staleDate: nil),
                    dismissalPolicy: .immediate
                )
        }
        self.startTime = nil
    }
#endif
}

