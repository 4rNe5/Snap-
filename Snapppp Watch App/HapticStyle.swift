//
//  HapticStyle.swift
//  Snapppp
//
//  Created by 4rNe5 on 10/31/24.
//

import WatchKit
import Foundation

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
            // 약한 진동 notification 사용
            WKInterfaceDevice.current().play(.notification)
            
        case .medium:
            // 중간 세기 success 사용
            WKInterfaceDevice.current().play(.success)
            
        case .heavy:
            // 강한 진동 notification과 success를 연속사용
            WKInterfaceDevice.current().play(.notification)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                WKInterfaceDevice.current().play(.success)
            }
            
        case .double:
            // 더블 진동 success 사용
            WKInterfaceDevice.current().play(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                WKInterfaceDevice.current().play(.success)
            }
        }
    }
}
