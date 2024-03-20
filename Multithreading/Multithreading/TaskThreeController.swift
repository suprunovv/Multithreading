//
//  TaskThreevController.swift
//  Multithreading
//
//  Created by MacBookPro on 19.03.2024.
//

import UIKit

final class TaskThreeController: UIViewController {
    

    let infinityThread = InfinityLoop()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            infinityThread.start()
            print(infinityThread.isExecuting)
            sleep(5)
            infinityThread.cancel()
            print(infinityThread.isCancelled)
            sleep(1)
            print(infinityThread.isFinished)
    }
}



class InfinityLoop: Thread {
    var counter = 0
    
    override func main() {
        while counter < 30 && !isCancelled {
            counter += 1
            print(counter)
            InfinityLoop.sleep(forTimeInterval: 1)
        }
    }
}


