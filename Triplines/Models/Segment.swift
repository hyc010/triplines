import Foundation
import SwiftData
import MapKit

/// 一段行程：从 A 到 B，使用某种交通方式
@Model
final class Segment {
    var id: UUID = UUID()
    var modeRaw: String = "flight"
    var date: Date = Date()
    var note: String = ""

    var fromName: String = ""
    var fromLat: Double = 0
    var fromLon: Double = 0
    var fromCountryCode: String?
    var fromCountry: String?
    var fromCity: String?

    var toName: String = ""
    var toLat: Double = 0
    var toLon: Double = 0
    var toCountryCode: String?
    var toCountry: String?
    var toCity: String?

    init(mode: TransportMode, date: Date, from: Place, to: Place, note: String = "") {
        self.id = UUID()
        self.modeRaw = mode.rawValue
        self.date = date
        self.note = note

        self.fromName = from.name
        self.fromLat = from.latitude
        self.fromLon = from.longitude
        self.fromCountryCode = from.countryCode
        self.fromCountry = from.country
        self.fromCity = from.city

        self.toName = to.name
        self.toLat = to.latitude
        self.toLon = to.longitude
        self.toCountryCode = to.countryCode
        self.toCountry = to.country
        self.toCity = to.city
    }

    var mode: TransportMode {
        TransportMode(rawValue: modeRaw) ?? .flight
    }

    var fromCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: fromLat, longitude: fromLon)
    }

    var toCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: toLat, longitude: toLon)
    }

    /// 地图上绘制的线
    var polyline: MKPolyline {
        let coords = [fromCoordinate, toCoordinate]
        if mode.usesGeodesic {
            return MKGeodesicPolyline(coordinates: coords, count: coords.count)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }

    /// 两点间直线距离（公里）
    var distanceKm: Double {
        let a = CLLocation(latitude: fromLat, longitude: fromLon)
        let b = CLLocation(latitude: toLat, longitude: toLon)
        return a.distance(from: b) / 1000
    }
}

/// 去过的地点（由行程的起点和终点汇总得到）
struct VisitedPlace: Identifiable {
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D
}

extension Array where Element == Segment {
    /// 去重后的到访地点
    var visitedPlaces: [VisitedPlace] {
        var seen = Set<String>()
        var result: [VisitedPlace] = []
        for segment in self {
            let ends: [(String, String?, CLLocationCoordinate2D)] = [
                (segment.fromName, segment.fromCity, segment.fromCoordinate),
                (segment.toName, segment.toCity, segment.toCoordinate)
            ]
            for (name, city, coordinate) in ends {
                let key = city ?? name
                if seen.insert(key).inserted {
                    result.append(VisitedPlace(id: key, name: key, coordinate: coordinate))
                }
            }
        }
        return result
    }
}
