//
//  TastCompletionVC.swift
//  BackgroundModes
//
//  Created by AbdurRehmanNineSol on 13/09/2022.
//

import UIKit

class TaskCompletionVC: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    static let maxValue: Double = 9940113804746346429.0
    var previous:Double = 1
    var current:Double = 1
    var position:Double = 1
    var updateTimer: Timer?
    var sceneBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Fibonacci Computations"
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func tapStartStopBtn(_ sender: UIButton) {
        if sender.titleLabel?.text == "Start Task" {
            sender.setTitle("Stop Task", for: .normal)
            resetCalculations()
            updateTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
              self?.calculateNextNumber()
               
            }
        }
        else {
            sender.setTitle("Start Task", for: .normal)
            updateTimer?.invalidate()
            updateTimer = nil
            endBackgroundTaskIfActive()
            label.text = "Fibonacci Computations"
        }
    }
    
    func registerBGTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            print("iOS has signaled time has expired!")
            self?.endBackgroundTaskIfActive()
        }
    }
    
    func endBackgroundTaskIfActive() {
        let isBackgroundTaskActive = backgroundTask != .invalid
        if isBackgroundTaskActive {
            print("Background task ended.")
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    func resetCalculations() {
         previous = 1
         current = 1
         position = 1
    }
    
    
    func calculateNextNumber() {
        
        let result = current + previous
        
        if position < 100 {
            previous = current
            current = result
            position += 1
        } else {
            backgroundTask = .invalid
            updateTimer?.invalidate()
            startBtn.setTitle("Start Task", for: .normal)
        }
//
        label.text = "Position \(self.position) = \(self.current)"
        
        switch UIApplication.shared.applicationState {
      
        case .background:
            let timeRemaining = UIApplication.shared.backgroundTimeRemaining
            if timeRemaining < Double.greatestFiniteMagnitude {
                let secondsRemaining = String(format: "%.1f seconds remaining", timeRemaining)
                print("App is bacground - Position \(self.position) = \(self.current) - \(secondsRemaining)")
            }

        case .inactive:
            if sceneBool {
                sceneBool = false
                registerBGTask()
                print("inactive")
            }
            
        case .active:
            if !sceneBool {
                sceneBool = true
                endBackgroundTaskIfActive()
                print("active")
            }
            sceneBool = true
        default:
            break
            
        }
    }
    
}


//switch UIApplication.shared.applicationState {
//case .background:
//    let isTimerRunning = self?.updateTimer != nil
//    let isTaskUnregistered = self?.backgroundTask == .invalid
//
//  if isTimerRunning && isTaskUnregistered {
//      self?.registerBGTask()
//  }
//case .active:
//    self?.endBackgroundTaskIfActive()
//default:
//  break
//}

