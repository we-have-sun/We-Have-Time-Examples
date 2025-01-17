import SwiftUI
import SwiftData
import WeHaveTime

struct EditProjectView: View {
    @Bindable var project: TimeEntry
    
    var body: some View {
        // Platform-specific logic
        #if os(iOS)
        Form {
            TextField("Name", text: $project.name)
            DatePicker("Creation Date", selection: $project.createdAt)
        }
        .navigationTitle("Edit Project")
        .navigationBarTitleDisplayMode(.inline)
        #elseif os(macOS)
        VStack(alignment: .leading) {
            TextField("Name", text: $project.name)
                .padding()
            DatePicker("Creation Date", selection: $project.creationDate)
                .padding()
            
            // macOS-specific buttons for save and cancel
            HStack {
                Button("Save") {
                    // Save project action
                }
                Button("Cancel") {
                    // Cancel action
                }
            }
            .padding(.top)
        }
        .frame(width: 400, height: 200)  // Set specific window size for macOS
        .padding()
        .navigationTitle("Edit Project")  // Won't appear as a navigation bar on macOS
        #endif
    }
}
