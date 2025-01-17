import SwiftUI
import SwiftData
import WeHaveTime

struct TimeDisplay: View {
   
    var project: ProjectModel
    
    init(project: TimeEntry) {
            let projectModel = ProjectModel(project: project)
            self.project = projectModel
        }
    
    var body: some View{
        ForEach(project.project.subentries) { time in
            if time.isRunning {
                RunningTime(time: time)
            } else {
                Text("Past Duration: \(time.duration)")
                    .font(.caption)
            }
            
            
        }
    }
}
