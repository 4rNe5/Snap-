enum HapticStyle: String, CaseIterable {
    case none = "없음"
    case light = "약하게"
    case medium = "보통"
    case heavy = "강하게"
    case double = "두번"
    
    func play() {
        switch self {
        case .none:
            break
        case .light:
            WKInterfaceDevice.current().play(.click)
        case .medium:
            WKInterfaceDevice.current().play(.notification)
        case .heavy:
            WKInterfaceDevice.current().play(.directionUp)
        case .double:
            WKInterfaceDevice.current().play(.click)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                WKInterfaceDevice.current().play(.click)
            }
        }
    }
}