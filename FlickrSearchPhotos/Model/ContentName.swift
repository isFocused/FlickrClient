//
//  ContentName.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 03.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

struct ContentName: Codable {
    var content: String?
    
    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}
