//
//  DogCollectionViewCell.swift
//  ReactiveDogs
//
//  Created by Marcel Chaucer on 12/8/17.
//  Copyright © 2017 Marcel Chaucer. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class DogCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dogImage: UIImageView! {
        didSet {
            print("This is setting in the collection view cell")
        }
    }
    
    var viewModel: DogCellViewModel! {
        didSet {
            dogImage.reactive.image <~ viewModel.dogImage
        }
    }
    
   
    
}
