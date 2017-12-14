//
//  Dog.swift
//  ReactiveDogs
//
//  Created by Marcel Chaucer on 12/8/17.
//  Copyright © 2017 Marcel Chaucer. All rights reserved.
//

import Foundation

struct ResultWrapper: Codable {
    let data: [Dog]
}

struct Dog: Codable {
    let url: String
}

