//
//  SettingsView.swift
//  Snapppp
//
//  Created by 4rNe5 on 10/31/24.
//
import SwiftUI
import WatchKit

struct SettingsView: View {
    @ObservedObject var snapDetector: SnapDetector
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("감지 설정")) {
                Toggle("스냅 감지", isOn: Binding(
                    get: { snapDetector.isEnabled },
                    set: { _ in snapDetector.toggleDetection() }
                ))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("감도")
                    Slider(value: Binding(
                        get: { snapDetector.snapThreshold },
                        set: { snapDetector.snapThreshold = $0 }
                    ), in: 1.0...5.0, step: 0.1)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("최소 간격(초)")
                    Slider(value: Binding(
                        get: { snapDetector.minTimeBetweenSnaps },
                        set: { snapDetector.minTimeBetweenSnaps = $0 }
                    ), in: 0.1...2.0, step: 0.1)
                }
            }
            
            Section(header: Text("햅틱 피드백")) {
                Picker("진동 강도", selection: $snapDetector.hapticStyle) {
                    ForEach(HapticStyle.allCases, id: \.self) { style in
                        Text(style.rawValue).tag(style)
                    }
                }
                
                Button("테스트") {
                    snapDetector.hapticStyle.play()
                }
            }
            
            Section(header: Text("정보")) {
                Text("버전 1.0.0")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("완료") {
                    dismiss()
                }
            }
        }
    }
}

