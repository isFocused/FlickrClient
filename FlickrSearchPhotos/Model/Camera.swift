//
//  Camera.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 03.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

struct Camera: Codable {
    
    let id: String
    let name: ContentName
    var images: Images?
    var details: Details?
}
