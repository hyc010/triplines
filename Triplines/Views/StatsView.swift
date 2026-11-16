import SwiftUI
import SwiftData

struct StatsView: View {
    @Query(sort: \Segment.date) private var segments: [Segment]

    private struct CountryItem: Identifiable {
        let id: String
        let name: String
    }

    private var countries: [CountryItem] {
        var seen = Set<String>()
        var result: [CountryItem] = []
        for segment in segments {
            let pairs: [(String?, String?)] = [
                (segment.fromCountryCode, segment.fromCountry),
                (segment.toCountryCode, segment.toCountry)
            ]
            for (code, name) in pairs {
                guard let code = code else { continue }
                if seen.insert(code).inserted {
                    result.append(CountryItem(id: code, name: name ?? code))
                }
            }
        }
        return result
    }

    private var cities: [String] {
        var seen = Set<String>()
        var result: [String] = []
        for segment in segments {
            for city in [segment.fromCity, segment.toCity] {
                guard let city = city else { continue }
                if seen.insert(city).inserted {
                    result.append(city)
                }
            }
        }
        return result
    }

    private var totalDistance: Int {
        Int(segments.reduce(0) { $0 + $1.distanceKm })
    }

    var body: some View {
        NavigationStack {
            List {
                Section("总览") {
                    statRow(title: "国家和地区", value: "\(countries.count)")
                    statRow(title: "城市", value: "\(cities.count)")
                    statRow(title: "行程段数", value: "\(segments.count)")
                    statRow(title: "总里程", value: "\(totalDistance) 公里")
                }

                Section("按交通方式") {
                    ForEach(TransportMode.allCases) { mode in
                        let items = segments.filter { $0.mode == mode }
                        if !items.isEmpty {
                            HStack {
                                Label(mode.title, systemImage: mode.symbol)
                                Spacer()
                                Text("\(items.count) 段 · \(Int(items.reduce(0) { $0 + $1.distanceKm })) 公里")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("已点亮的国家和地区") {
                    if countries.isEmpty {
                        Text("添加行程后会显示在这里")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(countries) { country in
                        Text("\(flag(for: country.id)) \(country.name)")
                    }
                }

                Section("已点亮的城市") {
                    if cities.isEmpty {
                        Text("添加行程后会显示在这里")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(cities, id: \.self) { city in
                        Text(city)
                    }
                }
            }
            .navigationTitle("统计")
        }
    }

    private func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }

    /// 由两位国家代码生成旗帜符号
    private func flag(for code: String) -> String {
        var result = ""
        for scalar in code.uppercased().unicodeScalars {
            if let flagScalar = Unicode.Scalar(127_397 + scalar.value) {
                result.unicodeScalars.append(flagScalar)
            }
        }
        return result
    }
}
