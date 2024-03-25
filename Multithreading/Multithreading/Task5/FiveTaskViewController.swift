//
//  FiveTaskViewController.swift
//  Multithreading
//
//  Created by MacBookPro on 24.03.2024.
//

import UIKit

class FiveTaskViewController: UIViewController {
    
    let networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Task {
//            await printMessage()
//        }
        oneTask()
    }
    
    /// 5.1
    /// В начале мы используем асинхронное выполнение через dispatchQueue на главной очереди асинхронно
    /// используя Таск (Который выполняет блок кода асинхронно) по сути мы делаем тоже самое, не указывая очередь, а исполняя блок кода асинхронно на той очереди в которой вызвали
    func oneTask()  {
        print(1)
//        DispatchQueue.main.async {
//            print(2)
//            print(Thread.current)
//        }
        Task {
            print(2)
            print(Thread.current)
        }
        print(3)
    }
    
    /// 5.2 Помечая метод как @MainActor мы выполняем его на главном потоке
    func twoTask() {
        print(1)
        DispatchQueue.global().async {
            Task { @MainActor in
                print(Thread.current)
                print(2)
            }
        }
        print(3)
    }
    
    
    /// 5.3
    func threTask() {
        print("Task 1 is finished")
        Task.detached(priority: .userInitiated) {
            for i in 0...50 {
                print(i)
            }
        }
        print("Task 2 is finished")
        print(Thread.current)
        print("Task 3 is finished")
    }
    
    /// 5.4
    func randomD6() async ->  Int {
        Int.random(in: 1...6)
    }
    
    /// 5.5
//    func fetchMessagesResult() async -> [Message] {
//        return await withCheckedContinuation { continuation in
//            NetworkService().fetchMessages(completion: { result in
//                continuation.resume(returning: result)
//            })
//        }
//    }
    
    enum MessageError: Error {
        case emptyMessage
    }
    
    
    /// 5.6
    func fetchMessagesResult() async throws -> [Message] {
        return try await withCheckedThrowingContinuation({ continuation in
            NetworkService().fetchMessages { result in
                if result.isEmpty {
                    continuation.resume(throwing: MessageError.emptyMessage)
                } else {
                    continuation.resume(returning: result)
                }
            }
        })
    }
    /// 5.7
    func getAverageTemperature() async {
        let fetchTask = Task { () -> Double in
            let url = URL(string: "https://hws.dev/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            let sum = readings.reduce(0, +)
            return sum / Double(readings.count)
        }
           
        fetchTask.cancel()

           do {
               let result = try await fetchTask.value
               print("Average temperature: \(result)")
           } catch {
               print("Failed to get data.")
           }
       }
    
    /// 5.8
    func printMessage() async {
        let string = await withTaskGroup(of: String.self) { group -> String in
            ["Hello", "My", "Road", "Map", "Group"].forEach { word in
                group.addTask {
                    word
                }
            }
        var collected = [String]()
        for await value in group {
            collected.append(value)
        }
        return collected.joined(separator: " ")
       }
            print(string)
    }

}

struct Message: Decodable, Identifiable {
    let id: Int
    let from: String
    let message: String
}

class NetworkService {
    func fetchMessages(completion: @escaping ([Message]) -> Void) {
        let url = URL(string: "https://hws.dev/user-messages.json")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let messages = try? JSONDecoder().decode([Message].self, from: data) {
                    completion(messages)
                    return
                }
            }
            completion([])
        }
        .resume()
    }
}
