import SwiftUI
import SwiftData
import MapKit

struct MapScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Segment.date) private var segments: [Segment]

    @State private var isGlobe = true
    @State private var showingAdd = false
    @State private var center = CLLocationCoordinate2D(latitude: 30, longitude: 110)
    @State private var position: MapCameraPosition = .camera(
        MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 30, longitude: 110),
                  distance: MapScreen.globeDistance)
    )

    private static let globeDistance: Double = 25_000_000
    private static let flatDistance: Double = 9_000_000

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $position) {
                ForEach(segments) { segment in
                    MapPolyline(segment.polyline)
                        .stroke(segment.mode.color, lineWidth: 2.5)
                }

                ForEach(segments.visitedPlaces) { place in
                    MapCircle(center: place.coordinate, radius: 60_000)
                        .foregroundStyle(Color.yellow.opacity(0.35))

                    Annotation(place.name, coordinate: place.coordinate) {
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 9, height: 9)
                            .shadow(color: .yellow, radius: 6)
                    }
                }
            }
            .mapStyle(isGlobe ? .hybrid(elevation: .realistic) : .standard(elevation: .flat))
            .onMapCameraChange { context in
                center = context.camera.centerCoordinate
            }
            .ignoresSafeArea(edges: .top)

            VStack(spacing: 12) {
                controlButton(systemImage: isGlobe ? "map.fill" : "globe.asia.australia.fill") {
                    toggleView()
                }
                controlButton(systemImage: "plus") {
                    showingAdd = true
                }
            }
            .padding(.trailing, 14)
            .padding(.top, 8)

            if segments.isEmpty {
                emptyHint
            }
        }
        .safeAreaInset(edge: .bottom) {
            if !segments.isEmpty {
                legend
            }
        }
        .sheet(isPresented: $showingAdd) {
            AddSegmentView()
        }
    }

    // MARK: - 子视图

    private func controlButton(systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial, in: Circle())
        }
        .buttonStyle(.plain)
    }

    private var legend: some View {
        let modes = TransportMode.allCases.filter { mode in
            segments.contains { $0.mode == mode }
        }
        return HStack(spacing: 14) {
            ForEach(modes) { mode in
                HStack(spacing: 4) {
                    Circle()
                        .fill(mode.color)
                        .frame(width: 8, height: 8)
                    Text(mode.title)
                        .font(.caption)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: Capsule())
        .padding(.bottom, 8)
    }

    private var emptyHint: some View {
        VStack(spacing: 12) {
            Text("还没有行程")
                .font(.headline)
            Text("点右上角的加号添加一段行程，或先载入示例看看效果。")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("载入示例行程") {
                SampleData.insert(into: modelContext)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    // MARK: - 操作

    private func toggleView() {
        isGlobe.toggle()
        let distance = isGlobe ? MapScreen.globeDistance : MapScreen.flatDistance
        withAnimation(.easeInOut(duration: 1.0)) {
            position = .camera(MapCamera(centerCoordinate: center, distance: distance))
        }
    }
}
