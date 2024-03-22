//
//  TaskThreViewController.swift
//  Multithreading
//
//  Created by MacBookPro on 22.03.2024.
//

import UIKit

class TaskThreViewController: UIViewController {
    
    let resourceASemaphore = DispatchSemaphore(value: 1)
    let resourceBSemaphore = DispatchSemaphore(value: 1)
    var sharedResource = 0
    var people1 = People1()
    var people2 = People2()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // oneProblem()
       // twoProblem()
        // threProblem()
       // taskFiveArray()
        
        DispatchQueue.global().async {
                self.thread1()
            }

        DispatchQueue.global().async {
                self.thread2()
            }
        
        
    }
    
    private func oneProblem() {
        /// Проблема дедлок, возникает из за того что мы вызываем синк на последовательной очереди
        /// Решение 1 использовать асинк, решение 2  сделать очередь последовательной
        let serialQueue = DispatchQueue(label: "com.example.myQueue")

        serialQueue.async {
           serialQueue.async {
               print("This will never be printed.")
           }
        }
    }
    
    private func twoProblem() {
        /// Проблема дата рейсинг, разные потоки одновременно записывают данные в наш ресурс
        /// решение 1- ограничить доступ к ресурсу для других потоков через семафор
        /// решение 2 - Изменить приоритет для очереди
        DispatchQueue.global(qos: .userInitiated).async {
            for _ in 1...100 {
                self.sharedResource += 1
                }
            }
        DispatchQueue.global(qos: .background).async {
            for _ in 1...100 {
                self.sharedResource += 1
            }
        }
    }
    
    /// Тут была проблема лайвлок, решение было выстроить очереди таким образом, что бы у нас изначально отработал блок кода меняющий флаг на true
    private func threProblem() {
        let thread1 = Thread {
            self.people1.walkPast(with: self.people2)
        }

        thread1.start()

        let thread2 = Thread {
            self.people2.walkPast(with: self.people1)
        }

        thread2.start()
    }
    
    //4.4  Проблема liveLock оба потомка ожидают освобождения ресурса, который захвачен другим потоком, как вариант решения, использование одного семафора 
        func thread1() {
            print("Поток 1 пытается захватить Ресурс A")
            resourceASemaphore.wait() // Захват Ресурса A
            print("Поток 1 захватил Ресурс A и пытается захватить Ресурс B")
            Thread.sleep(forTimeInterval: 1) // Имитация работы для демонстрации livelock
            print("Поток 1 захватил Ресурс B")
                
            //resourceBSemaphore.signal()
            resourceASemaphore.signal()
            }

        func thread2() {
            print("Поток 2 пытается захватить Ресурс B")
            resourceASemaphore.wait() // Захват Ресурса B
            print("Поток 2 захватил Ресурс B и пытается захватить Ресурс A")
            Thread.sleep(forTimeInterval: 1)
            print("Поток 2 захватил Ресурс A")
            resourceASemaphore.signal()
       }
    
    private func taskFiveArray() {
        let service = ArrayAdditionService()
            for i in 1...10 {
                service.addElement(i)
            }
            service.cancelAddition()
    }

}

class People1 {
    var semaphore = DispatchSemaphore(value: 1)
    var isDifferentDirections = false;
    
    func walkPast(with people: People2) {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                while (!people.isDifferentDirections) {
                    print("People1 не может обойти People2")
                    sleep(1)
                }
            }
            
        }
        DispatchQueue.global().async {
            print("People1 смог пройти прямо")
            self.isDifferentDirections = true
        }
            
    }
}

class People2 {
    var isDifferentDirections = false;
    
    func walkPast(with people: People1) {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                while (!people.isDifferentDirections) {
                    print("People2 не может обойти People1")
                    sleep(1)
                }
            }
        }
        
        DispatchQueue.global().async {
            print("People2 смог пройти прямо")
            self.isDifferentDirections = true
        }
    }
}


class ArrayAdditionService {
    private var array = [Int]()
    private var pendingWorkItems = [DispatchWorkItem]()

    func addElement(_ element: Int) {
        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.array.append(element)
            print("Элемент \(element) успешно добавлен в массив.")
        }
        pendingWorkItems.append(newWorkItem)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            DispatchQueue.main.async(execute: newWorkItem)
        }
    }
    func cancelAddition() {
        guard let lastWorkItem = pendingWorkItems.last else {
            print("Нет операций для отмены.")
            return
        }
        lastWorkItem.cancel()
    }
}
