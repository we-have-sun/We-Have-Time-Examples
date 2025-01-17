
import SwiftUI
import SwiftData
import WeHaveTime

struct TimerTotalView: View {
    var project: ProjectModel
    init(project: TimeEntry) {
            let projectModel = ProjectModel(project: project)
            self.project = projectModel
        }
    
    var totalOfTimes: Int64 {
        let times: [TimeEntry] = project.project.subentries
        return times.reduce(0) { (result, time) -> Int64 in
                    return result + time.duration
                }
    }
    var formattedTime: String {
        let days = totalOfTimes / 86_400
        let hours = (totalOfTimes % 86_400) / 3_600
        let minutes = (totalOfTimes % 3_600) / 60
        let seconds = totalOfTimes % 60
        
        return String(format: "%02dd %02dh %02dm %02ds", days, hours, minutes, seconds)
    }
    var body: some View{
            Text("Total time: \(formattedTime)")
                .font(.caption)
       
    }
}
