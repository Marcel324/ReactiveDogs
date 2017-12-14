//
//  DogViewModel.swift
//  ReactiveDogs
//
//  Created by Marcel Chaucer on 12/8/17.
//  Copyright © 2017 Marcel Chaucer. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import ReactiveCocoa

class DogViewModel: NSObject {
    
    private var allDogImages = [Dog]() {
        didSet {
            self.dogsPipe.input.send(value: ())
            print("In the didset")
        }
    }
        
    let dogsPipe = Signal<Void, NoError>.pipe()
    
    override init() {
        super.init()
        fetchDogs().on(failed: { error in
            print(error)
        },  value: { [weak self] (dogs) in
            if let dogs = self?.allDogImages {
                self?.allDogImages = dogs
            }
        }).start()
    }
    
    private func fetchDogs() -> SignalProducer<[Dog], APIError> {
        
        return APIManager.getData(endpoint: "https://api.thedogapi.co.uk/v2/dog.php?limit=20").attemptMap({ data in
            
            do {
                let resultWrapper = try JSONDecoder().decode(ResultWrapper.self, from: data)
                self.allDogImages = resultWrapper.data
                return Result(value: self.allDogImages)
            }
            catch(let error) {
                print("WHOOPS!!")
                print(error)
                return Result(error: APIError.dataMappingError(error: error))
            }
        })
    }
    
    func fetchCellViewModel( at indexPath: IndexPath ) -> DogCellViewModel {
        let dog = allDogImages[indexPath.row]
        let cellViewModel = DogCellViewModel(dog: dog)
        return cellViewModel
    }
    
    func itemsInSection() -> Int {
        return allDogImages.count
    }
    
}
