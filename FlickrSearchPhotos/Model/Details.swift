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
    
    func extractValues() -> [String: String] {
        var distionary = [String: String]()
        
        if let megapixel = megapixels?.content {
            distionary["Megapixels:"] = megapixel
        }
        
        if let screenSize = lcdScreenSize?.content {
            distionary["Screen size:"] = screenSize
        }
        
        if let memory = memoryType?.content {
            distionary["Memory type:"] = memory
        }
        
        return distionary
    }
}
