import SwiftUI

/// 交通方式
enum TransportMode: String, CaseIterable, Identifiable {
    case flight
    case train
    case car
    case bus
    case ship
    case walk

    var id: String { rawValue }

    var title: String {
        switch self {
        case .flight: return "航班"
        case .train: return "火车"
        case .car: return "自驾"
        case .bus: return "大巴"
        case .ship: return "轮船"
        case .walk: return "步行"
        }
    }

    var symbol: String {
        switch self {
        case .flight: return "airplane"
        case .train: return "tram.fill"
        case .car: return "car.fill"
        case .bus: return "bus.fill"
        case .ship: return "ferry.fill"
        case .walk: return "figure.walk"
        }
    }

    var color: Color {
        switch self {
        case .flight: return .cyan
        case .train: return .orange
        case .car: return .green
        case .bus: return .purple
        case .ship: return .blue
        case .walk: return .pink
        }
    }

    /// 航班和轮船按大圆航线绘制
    var usesGeodesic: Bool {
        self == .flight || self == .ship
    }
}
