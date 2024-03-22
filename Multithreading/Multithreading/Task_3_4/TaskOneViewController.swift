//
//  TaskOneViewController.swift
//  Multithreading
//
//  Created by MacBookPro on 21.03.2024.
//

import UIKit

class TaskOneViewController: UIViewController {
    
    let semaphore = DispatchSemaphore(value: 1)
    let phrasesService = PhrasesService()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // taskOne()
        taskTwo()
    }
    
    /// Решение гонки через семафор
//    private func taskOne() {
//        for i in 0..<10 {
//            DispatchQueue.global().async {
//                self.semaphore.wait()
//                self.phrasesService.addPhrase("Phrase \(i)")
//                self.semaphore.signal()
//            }
//        }
//        Thread.sleep(forTimeInterval: 1)
//        semaphore.wait()
//        print(phrasesService.phrases)
//        semaphore.signal()
//    }
    
    // Решение через actor
    private func taskTwo() {
        for i in 0..<10 {
            Task {
                await phrasesService.addPhrase("Pharse \(i)")
            }
        }
        Task {
            await print(phrasesService.phrases)
        }
    }
}

actor PhrasesService {
    var phrases: [String] = []
    
    func addPhrase(_ phrase: String) {
        phrases.append(phrase)
    }
}
