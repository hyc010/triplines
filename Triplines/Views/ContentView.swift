import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapScreen()
                .tabItem {
                    Label("足迹", systemImage: "globe.asia.australia.fill")
                }

            TripListView()
                .tabItem {
                    Label("行程", systemImage: "list.bullet")
                }

            StatsView()
                .tabItem {
                    Label("统计", systemImage: "chart.bar.fill")
                }
        }
    }
}
