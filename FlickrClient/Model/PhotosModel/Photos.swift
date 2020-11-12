//
//  Photos.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 15.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

struct Photos: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [Photo]
}
