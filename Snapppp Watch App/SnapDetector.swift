//
//  SnapDetector.swift
//  Snapppp
//
//  Created by 4rNe5 on 10/31/24.
//
import CoreMotion
import SwiftUI

class SnapDetector: ObservableObject {
    private let motionManager = CMMotionManager()
    private let motionQueue = OperationQueue()
    @Published var snapCount = 0
    @Published var isEnabled = false
    @Published var hapticStyle: HapticStyle = .none
    
    var snapThreshold: Double = 2.5
    var minTimeBetweenSnaps: Double = 0.2
    private var lastSnapTime = Date()
    
    init() {
        motionQueue.name = "MotionQueue"
        setupMotionDetection()
    }
    
    func setupMotionDetection() {
        guard motionManager.isAccelerometerAvailable else {
            print("가속도계를 사용할 수 없습니다")
            return
        }
        
        motionManager.accelerometerUpdateInterval = 1.0 / 60.0
        
        motionManager.startAccelerometerUpdates(to: motionQueue) { [weak self] (data, error) in
            guard let self = self,
                  let acceleration = data?.acceleration,
                  self.isEnabled else { return }
            
            let magnitude = abs(acceleration.x) + abs(acceleration.y) + abs(acceleration.z)
            
            let currentTime = Date()
            let timeSinceLastSnap = currentTime.timeIntervalSince(self.lastSnapTime)
            
            if magnitude > self.snapThreshold && timeSinceLastSnap > self.minTimeBetweenSnaps {
                DispatchQueue.main.async {
                    self.snapCount += 1
                    self.hapticStyle.play()
                }
                self.lastSnapTime = currentTime
            }
        }
        
        isEnabled = true
    }
    
    func resetCount() {
        snapCount = 0
    }
    
    func toggleDetection() {
        isEnabled.toggle()
        if isEnabled {
            setupMotionDetection()
        } else {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    deinit {
        motionManager.stopAccelerometerUpdates()
    }
}
