//
//  TaskTwoViewController.swift
//  Multithreading
//
//  Created by MacBookPro on 22.03.2024.
//

import UIKit

class TaskTwoViewController: UIViewController {

    let asyncWorker = AsyncWorker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        asyncWorker.doJobs(postNumbers: 1, 2, 3, 4, 5) { posts in
            print(Thread.current)
            print(posts.map { $0.id })
        }
    }
}

class AsyncWorker {
    let group = DispatchGroup()
    
    func doJobs(postNumbers: Int..., completion: @escaping ([Post]) -> Void) {
        var posts = [Post]() {
            didSet {
                posts.sort {$0.id < $1.id}
            }
        }

        for i in postNumbers {
            group.enter()
            URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/\(i)")!)) { data, response, error in
                guard let data = data else {
                    return
                }
                if let post = try? JSONDecoder().decode(Post.self, from: data) {
                    posts.append(post)
                }
                self.group.leave()
            }
            .resume()
        }
        group.notify(queue: .main) {
            completion(posts)
        }
    }
}

struct Post: Codable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}
