// ContentView.swift
import SwiftUI
import CoreMotion

struct ContentView: View {
    @StateObject private var snapDetector = SnapDetector()
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                // 메인
                ZStack {
                    Circle()
                        .stroke(Color.red.opacity(0.3), lineWidth: 12)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: min(CGFloat(snapDetector.snapCount) / 100.0, 1.0))
                        .stroke(Color.red, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.1), value: snapDetector.snapCount)
                    
                    VStack(spacing: 2) {
                        Text("\(snapDetector.snapCount)")
                            .font(.system(size: 36, weight: .bold))
                            .contentTransition(.numericText()) // 숫자 변경 애니메이션
                        Text("스냅")
                            .font(.system(size: 12))
                    }
                }
                .padding(.top, 5)
                
                // 컨트롤
                HStack(spacing: 20) {
                    Button(action: snapDetector.resetCount) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 20))
                    }
                    .frame(width: 44, height: 44)
                    
                    Button(action: { showingSettings.toggle() }) {
                        Image(systemName: "gear")
                            .font(.system(size: 20))
                    }
                    .frame(width: 44, height: 44)
                }
                .padding(.bottom, 5)
            }
//            .navigationTitle("스냅 카운터")
//            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingSettings) {
                SettingsView(snapDetector: snapDetector)
            }
        }
    }
}
