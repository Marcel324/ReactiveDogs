//
//  DogDetailPage.swift
//  ReactiveDogs
//
//  Created by Marcel Chaucer on 12/12/17.
//  Copyright © 2017 Marcel Chaucer. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import Result

class DogDetailPage: UIViewController {
    
    @IBOutlet weak var dogImage: UIImageView!
    var image:  UIImage!
    let imagePipe = Signal<UIImage, NoError>.pipe()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogImage.image = image
    }
    
}
