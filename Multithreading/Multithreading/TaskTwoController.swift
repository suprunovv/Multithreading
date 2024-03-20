//
//  TaskThreeController.swift
//  Multithreading
//
//  Created by MacBookPro on 19.03.2024.
//

import UIKit

final class TaskTwoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let timer = TimerThread(duration: 10)
        timer.start()
    }
    
}

final class TimerThread: Thread {
    private var timerDuration: Int
    private var timer: Timer!
    
    init(duration: Int) {
        self.timerDuration = duration
    }
    
    override func main() {
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        print(Thread.current)
        RunLoop.current.add(timer, forMode: .default)
        RunLoop.current.run()
    }
    
    @objc func updateTimer() {
        if timerDuration > 0 {
            print("Осталось \(timerDuration) секунд...")
            timerDuration -= 1
        } else {
            print("Время истекло!")
            timer.invalidate()
            // Остановка текущего run loop после завершения таймера
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
    }
}
