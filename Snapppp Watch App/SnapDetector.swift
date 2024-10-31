// SnapDetector.swift
class SnapDetector: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var snapCount = 0
    @Published var isEnabled = false
    
    var snapThreshold: Double = 3.0
    var minTimeBetweenSnaps: Double = 0.5
    private var lastSnapTime = Date()
    
    init() {
        setupMotionDetection()
    }
    
    func setupMotionDetection() {
        guard motionManager.isAccelerometerAvailable else {
            print("가속도계를 사용할 수 없습니다")
            return
        }
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self,
                  let acceleration = data?.acceleration,
                  self.isEnabled else { return }
            
            let magnitude = sqrt(
                pow(acceleration.x, 2) +
                pow(acceleration.y, 2) +
                pow(acceleration.z, 2)
            )
            
            let currentTime = Date()
            let timeSinceLastSnap = currentTime.timeIntervalSince(self.lastSnapTime)
            
            if magnitude > self.snapThreshold && timeSinceLastSnap > self.minTimeBetweenSnaps {
                self.snapCount += 1
                self.lastSnapTime = currentTime
                WKInterfaceDevice.current().play(.click)
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
}
