import SwiftUI
import SwiftData

@main
struct TriplinesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Segment.self)
    }
}
