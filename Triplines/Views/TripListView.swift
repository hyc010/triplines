import SwiftUI
import SwiftData

struct TripListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Segment.date, order: .reverse) private var segments: [Segment]
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            Group {
                if segments.isEmpty {
                    ContentUnavailableView("还没有行程",
                                           systemImage: "airplane.departure",
                                           description: Text("点右上角的加号添加第一段行程"))
                } else {
                    List {
                        ForEach(segments) { segment in
                            SegmentRow(segment: segment)
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .navigationTitle("行程")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddSegmentView()
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(segments[index])
        }
    }
}

struct SegmentRow: View {
    let segment: Segment

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: segment.mode.symbol)
                .foregroundStyle(segment.mode.color)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text("\(segment.fromName) → \(segment.toName)")
                    .font(.body)
                    .lineLimit(2)
                HStack(spacing: 8) {
                    Text(segment.date, format: .dateTime.year().month().day())
                    Text(segment.mode.title)
                    Text("\(Int(segment.distanceKm)) 公里")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}
