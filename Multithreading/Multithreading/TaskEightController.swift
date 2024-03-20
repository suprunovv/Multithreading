//
//  TaskEightController.swift
//  Multithreading
//
//  Created by MacBookPro on 20.03.2024.
//

import UIKit

class TaskEightController: UIViewController {

    private lazy var name = "I love RM"
    private var lock = NSLock()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateName()
    }
    
    // Тут была проблема с тем, что мы обращались к переменной типа lazy из двух потоков и она могла проинициализироватся 2 раза, для решения проблемы при обращении к переменной мы блокируем доступ к ней из других потоков

    func updateName() {
        DispatchQueue.global().async {
            self.lock.lock()
            print(self.name)
            self.lock.unlock()
            print(Thread.current)
        }
        lock.lock()
        print(self.name)
        lock.unlock()
    }
}
