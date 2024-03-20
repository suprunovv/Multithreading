//
//  TaskFiveController.swift
//  Multithreading
//
//  Created by MacBookPro on 19.03.2024.
//

import UIKit

final class TaskFiveController: UIViewController {

    private let lockQueue = DispatchQueue(label: "name.lock.queue")
    
    private var name = "Введите имя"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateName()
    }

    private func updateName() {
        DispatchQueue.global().async {
            self.lockQueue.async {
                self.name = "I love RM"
                print(Thread.current)
                print(self.name)
            }
        }
        
        lockQueue.async {
            print(self.name)
        }
    }
}

