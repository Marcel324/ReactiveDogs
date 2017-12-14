//
//  APIManager.swift
//  ReactiveDogs
//
//  Created by Marcel Chaucer on 12/8/17.
//  Copyright © 2017 Marcel Chaucer. All rights reserved.
//

import Foundation
import ReactiveSwift

enum APIError: Error {
    case jsonError(error: Error)
    case dataMappingError(error: Error)
    case unknown
}

class APIManager {
    
    static func getData(endpoint: String) -> SignalProducer<Data, APIError> {
        return SignalProducer { observer, disposable in
            guard let url = URL(string: endpoint) else { return }
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let myError = error {
                    print(myError)
                    observer.send(error: APIError.jsonError(error: myError))
                    observer.sendCompleted()
                }
                if let myData = data {
                    observer.send(value: myData)
                    observer.sendCompleted()
                }
            }
            task.resume()
        }
    }
}
