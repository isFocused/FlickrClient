//
//  Details.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 03.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

struct Details: Codable {
    var lcdScreenSize: ContentName?
    var megapixels: ContentName?
    var memoryType: ContentName?
    
    enum CodingKeys: String, CodingKey {
        case lcdScreenSize = "lcd_screen_size"
        case megapixels
        case memoryType = "memory_type"
    }
}
