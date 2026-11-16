import Foundation
import SwiftData

/// 示例行程，方便第一次打开时查看效果
enum SampleData {
    static let hangzhou = Place(name: "杭州东站", latitude: 30.2907, longitude: 120.2126, countryCode: "CN", country: "中国", city: "杭州")
    static let beijing = Place(name: "北京南站", latitude: 39.8652, longitude: 116.3786, countryCode: "CN", country: "中国", city: "北京")
    static let shanghai = Place(name: "上海浦东国际机场", latitude: 31.1443, longitude: 121.8083, countryCode: "CN", country: "中国", city: "上海")
    static let singapore = Place(name: "新加坡樟宜机场", latitude: 1.3644, longitude: 103.9915, countryCode: "SG", country: "新加坡", city: "新加坡")
    static let london = Place(name: "伦敦希思罗机场", latitude: 51.4700, longitude: -0.4543, countryCode: "GB", country: "英国", city: "伦敦")
    static let paris = Place(name: "巴黎北站", latitude: 48.8809, longitude: 2.3553, countryCode: "FR", country: "法国", city: "巴黎")
    static let tokyo = Place(name: "东京羽田机场", latitude: 35.5494, longitude: 139.7798, countryCode: "JP", country: "日本", city: "东京")
    static let newYork = Place(name: "纽约肯尼迪机场", latitude: 40.6413, longitude: -73.7781, countryCode: "US", country: "美国", city: "纽约")
    static let suzhou = Place(name: "苏州", latitude: 31.2990, longitude: 120.5853, countryCode: "CN", country: "中国", city: "苏州")

    static func insert(into context: ModelContext) {
        let day: TimeInterval = 86_400
        let now = Date()
        let items: [Segment] = [
            Segment(mode: .train, date: now.addingTimeInterval(-300 * day), from: hangzhou, to: beijing, note: "示例"),
            Segment(mode: .car, date: now.addingTimeInterval(-260 * day), from: hangzhou, to: suzhou, note: "示例"),
            Segment(mode: .flight, date: now.addingTimeInterval(-200 * day), from: shanghai, to: singapore, note: "示例"),
            Segment(mode: .flight, date: now.addingTimeInterval(-190 * day), from: singapore, to: london, note: "示例"),
            Segment(mode: .train, date: now.addingTimeInterval(-185 * day), from: london, to: paris, note: "示例"),
            Segment(mode: .flight, date: now.addingTimeInterval(-90 * day), from: shanghai, to: tokyo, note: "示例"),
            Segment(mode: .flight, date: now.addingTimeInterval(-30 * day), from: shanghai, to: newYork, note: "示例")
        ]
        for item in items {
            context.insert(item)
        }
    }
}
