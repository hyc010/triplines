import Foundation
import MapKit

/// 一个地点（机场、车站、城市等）
struct Place: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
    var countryCode: String?
    var country: String?
    var city: String?

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var subtitle: String {
        [city, country].compactMap { $0 }.joined(separator: " · ")
    }

    init(name: String,
         latitude: Double,
         longitude: Double,
         countryCode: String? = nil,
         country: String? = nil,
         city: String? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.countryCode = countryCode
        self.country = country
        self.city = city
    }

    init(mapItem: MKMapItem) {
        let placemark = mapItem.placemark
        self.name = mapItem.name ?? placemark.title ?? "未命名地点"
        self.latitude = placemark.coordinate.latitude
        self.longitude = placemark.coordinate.longitude
        self.countryCode = placemark.isoCountryCode
        self.country = placemark.country
        self.city = placemark.locality ?? placemark.administrativeArea
    }
}
