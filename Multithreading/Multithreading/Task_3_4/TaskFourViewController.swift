//
//  TaskFourViewController.swift
//  Multithreading
//
//  Created by MacBookPro on 22.03.2024.
//

import UIKit

class TaskFourViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        task4_4()
    }
    
    
    private func task4_2() {
        let operationFirst = RMOperation()
            let operationSecond = RMOperation()
                
               
            operationFirst.priority = .userInitiated
            operationFirst.completionBlock = {
                for _ in 0..<50 {
                    print(2)
                }
                print(Thread.current)
                print("Операция полностью завершена!")
                }
               
            operationFirst.start()
                

                
            operationSecond.priority = .background
            operationSecond.completionBlock = {
                for _ in 0..<50 {
                    print(1)
                }
                print(Thread.current)
                print("Операция полностью завершена!")
                }
            operationSecond.start()
    }
    
    
    private func task4_3() {
        let rmOperationQueue = RMOperationQueue()
            let rmOperation1 = RMOperation()
            rmOperation1.priority = .background
                
            rmOperation1.completionBlock = {
                print(1)
            }
                
            let rmOperation2 = RMOperation()
            rmOperation2.priority = .userInteractive
                
            rmOperation2.completionBlock = {
                print(2)
            }
        
            let rmOperation3 = RMOperation()
            rmOperation3.priority = .userInteractive
                
            rmOperation3.completionBlock = {
            print(3)
            }
            
            rmOperationQueue.addOperation(rmOperation1)
            rmOperationQueue.addOperation(rmOperation2)
            rmOperationQueue.addOperation(rmOperation3)
    }
    
    func task4_4() {
        let threadSafeArray = ThreadSafeArray()
        let operationQueue = OperationQueue()

        let firstOperation = FirstOperation(threadSafeArray: threadSafeArray)
        let secondOperation = SecondOperation(threadSafeArray: threadSafeArray)
        secondOperation.addDependency(firstOperation)

        operationQueue.addOperation(firstOperation)
        operationQueue.addOperation(secondOperation)

        // Дождитесь завершения операций перед выводом содержимого массива
        operationQueue.waitUntilAllOperationsAreFinished()

        print(threadSafeArray.getAll())
    }

    
}
// 4.1 Ошибка была в том, что протокол Sendable указывает на то, что наш обьект должен быть потоко безопастным
actor Posts {
        
}

enum State1: Sendable {
     case loading
     case data(String)
}
    
enum State2: Sendable {
     case loading
     case data(Posts)
}

// 4.2
protocol RMOperationProtocol {
    // Приоритеты
    var priority: DispatchQoS.QoSClass { get }
    // Выполняемый блок
    var completionBlock: (() -> Void)? { get }
    // Завершена ли операция
    var isFinished: Bool { get }
    // Метод для запуска операции
    func start()
}

class RMOperation: RMOperationProtocol {
    
    var priority: DispatchQoS.QoSClass = .utility
    
    var completionBlock: (() -> Void)?
    
    var isFinished: Bool = false
    var isExecuting: Bool = false
    
    func start() {
        isExecuting = true
        DispatchQueue.global(qos: priority).sync {
            self.completionBlock?()
        }
    }
}

// 4.3
protocol RMOperationQueueProtocol {
    /// Тут храним пул наших операций
    var operations: [RMOperation] { get }
    /// Добавляем наши кастомные операции в пул operations
    func addOperation(_ operation: RMOperation)
    /// Запускаем следующую
    func executeNextOperation()
}

final class RMOperationQueue: RMOperationQueueProtocol {
    var operations: [RMOperation] = []

    func addOperation(_ operation: RMOperation) {
        operations.append(operation)
        executeNextOperation()
    }

    func executeNextOperation() {
        if let nextOperation = operations.first(where: { !$0.isExecuting && !$0.isFinished }) {
            nextOperation.start()
            executeNextOperation()
        }
    }
}

// task 4.4 проблема была в одновременном обращении к общему ресурсу, решение: установка зависимости

class ThreadSafeArray {
    private var array: [String] = []

    func append(_ item: String) {
        array.append(item)
    }

    func getAll() -> [String] {
        return array
    }
}

// Определяем первую операцию для добавления строки в массив
class FirstOperation: Operation {
    let threadSafeArray: ThreadSafeArray

    init(threadSafeArray: ThreadSafeArray) {
        self.threadSafeArray = threadSafeArray
    }

    override func main() {
        if isCancelled { return }
        threadSafeArray.append("Первая операция")
    }
}

// Определяем вторую операцию для добавления строки в массив
class SecondOperation: Operation {
    // Создаем по образу первой операции
    let threadSafeArray: ThreadSafeArray
    
    init(threadSafeArray: ThreadSafeArray) {
        self.threadSafeArray = threadSafeArray
    }
    
    override func main() {
        if isCancelled { return }
        threadSafeArray.append("Вторая операция")
    }
}

