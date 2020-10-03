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
    
    func extractValues() -> [String] {
        var arrayStrings = [String]()
        
        if let megapixelString = megapixels?.content {
            arrayStrings.append(megapixelString)
        }
        
        if let screenSizeString = lcdScreenSize?.content {
            arrayStrings.append(screenSizeString)
        }
        
        if let memoryString = memoryType?.content {
            arrayStrings.append(memoryString)
        }
        
        return arrayStrings
    }
}
