import SwiftUI
import MapKit

/// 搜索并选择一个地点（机场、车站、城市等）
struct PlaceSearchView: View {
    let title: String
    let onSelect: (Place) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @State private var results: [Place] = []
    @State private var isSearching = false
    @State private var message: String?

    var body: some View {
        List {
            if isSearching {
                HStack {
                    ProgressView()
                    Text("搜索中…")
                        .foregroundStyle(.secondary)
                }
            }

            if let message = message {
                Text(message)
                    .foregroundStyle(.secondary)
            }

            ForEach(results) { place in
                Button {
                    onSelect(place)
                    dismiss()
                } label: {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(place.name)
                            .foregroundStyle(.primary)
                        if !place.subtitle.isEmpty {
                            Text(place.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "搜索机场、车站或城市")
        .onSubmit(of: .search) {
            Task {
                await search()
            }
        }
    }

    @MainActor
    private func search() async {
        let text = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        isSearching = true
        message = nil

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text

        do {
            let response = try await MKLocalSearch(request: request).start()
            results = response.mapItems.map { Place(mapItem: $0) }
            if results.isEmpty {
                message = "没有找到结果，请换个关键词"
            }
        } catch {
            results = []
            message = "没有找到结果，请换个关键词或检查网络"
        }

        isSearching = false
    }
}
