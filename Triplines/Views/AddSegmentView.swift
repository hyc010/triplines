import SwiftUI
import SwiftData

struct AddSegmentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var mode: TransportMode = .flight
    @State private var date = Date()
    @State private var from: Place?
    @State private var to: Place?
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("交通方式") {
                    Picker("方式", selection: $mode) {
                        ForEach(TransportMode.allCases) { item in
                            Label(item.title, systemImage: item.symbol).tag(item)
                        }
                    }
                    DatePicker("日期", selection: $date, displayedComponents: .date)
                }

                Section("路线") {
                    NavigationLink {
                        PlaceSearchView(title: "出发地") { place in
                            from = place
                        }
                    } label: {
                        placeLabel(title: "出发地", place: from)
                    }

                    NavigationLink {
                        PlaceSearchView(title: "目的地") { place in
                            to = place
                        }
                    } label: {
                        placeLabel(title: "目的地", place: to)
                    }
                }

                Section("备注") {
                    TextField("航班号、车次等（可不填）", text: $note)
                }
            }
            .navigationTitle("添加行程")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存") {
                        save()
                    }
                    .disabled(from == nil || to == nil)
                }
            }
        }
    }

    private func placeLabel(title: String, place: Place?) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(place?.name ?? "请选择")
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }

    private func save() {
        guard let from = from, let to = to else { return }
        let segment = Segment(mode: mode, date: date, from: from, to: to, note: note)
        modelContext.insert(segment)
        dismiss()
    }
}
