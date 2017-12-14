//
//  DogCellViewModel.swift
//  ReactiveDogs
//
//  Created by Marcel Chaucer on 12/8/17.
//  Copyright © 2017 Marcel Chaucer. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Result
import ReactiveSwift
import ReactiveCocoa
import AlamofireImage

let cache = NSCache<NSString, UIImage>()

class DogCellViewModel {
    private let dog: Dog!
    
    var dogImage = MutableProperty<UIImage?>(nil) 
    
    init(dog: Dog) {
        self.dog = dog
        fetchImage()
    }
    
    func fetchURL() -> URL {
        guard let urlString = URL(string: dog.url) else { return URL(string: "")! }
        return urlString
    }
    
    private func fetchImage() {
        guard let urlString = URL(string: dog.url) else { return }
        
        if let cachedImage = cache.object(forKey: urlString.absoluteString as NSString) {
            print("Getting Image From Cache")
            self.dogImage.value = cachedImage
            return
        }
        
        APIManager.getData(endpoint: dog.url).on(failed: { error in
            print(error)
        }, value: { [weak self] data in
            print("Fetching Dog Image")
            cache.setObject(UIImage(data: data)!, forKey: urlString.absoluteString as NSString)
            self?.dogImage.value = UIImage(data: data)
        }).start()
        }
    }
