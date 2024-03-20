//
//  TaskOneController.swift
//  Multithreading
//
//  Created by MacBookPro on 19.03.2024.
//

import UIKit

class TaskOneController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // В изначальном варианте, работа выполнялась в одном, главном потоке и имела последовательный характер, поток сперва выполнял первый цикл, а затем выполнял другой. Потом с помощью detachNewThread мы перевели первый цикл из основного потока в другой и теперь оба цикла выполнялись независимо друг от друга (поэтому в консоли мы получаем разные варианты вывода текста)
        
        Thread.detachNewThread {
            for _ in (0..<10) {
                 let currentThread = Thread.current
                 print("1, Current thread: \(currentThread)")
              }
        }
        
        for _ in (0..<10) {
            let currentThread = Thread.current
            print("2, Current thread: \(currentThread)")
        }
    }
}


