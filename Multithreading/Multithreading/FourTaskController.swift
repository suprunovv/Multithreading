//
//  FourTaskController.swift
//  Multithreading
//
//  Created by MacBookPro on 19.03.2024.
//

import UIKit

class FourTaskController: UIViewController {

    let threadDemon = ThreadPrintDemon()
    let threadAngel = ThreadPrintAngel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Сначала 1 потом 2
       // threadDemon.qualityOfService = .userInitiated
       // threadAngel.qualityOfService = .utility
        
        // сначала 2 потом 1
       // threadDemon.qualityOfService = .utility
       // threadAngel.qualityOfService = .userInitiated
        
        // вперемешку
        threadDemon.qualityOfService = .default
        threadAngel.qualityOfService = .default
        
        threadDemon.start()
        threadAngel.start()
    }
    
}

final class ThreadPrintDemon: Thread {
    override func main() {
        for _ in 0..<100 {
            print("1")
        }
    }
}

final class ThreadPrintAngel: Thread {
    override func main() {
        for _ in 0..<100 {
            print("2")
        }
    }
}
