//
//  JsonPhotoData.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 15.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

struct JsonPhotoData: Codable {
    let photos: Photos
    let stat: String
}
