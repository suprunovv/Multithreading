//
//  TaskSixController.swift
//  Multithreading
//
//  Created by MacBookPro on 20.03.2024.
//

import UIKit

final class TaskSixController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Выведет A C B, так как сперва идет выполнение в main очереди, а async встает в очередь и ждет завершения main
        
        print("A")
        DispatchQueue.main.async {
            print("B")
        }
            
        print("C")
    }

}
