//
//  SearchViewModelCell.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 08.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

protocol SearchViewModelCellProtocol {
    var name: String? { get }
    var imageStringUrl: String? { get }
    var isDetail: Bool { get }
    var details: [(ValueLabel, String)] { get }
    
    init(camera: Camera)
}

enum ValueLabel: String, CaseIterable {
    case megapixels = "Megapixels: \t"
    case lsdScreenSize = "Screen size: \t"
    case memoryType = "Memory type: \t"
}

class SearchViewModelCell: SearchViewModelCellProtocol {
    
    private let camera: Camera
    
    var name: String? {
        camera.name.content
    }
    
    var imageStringUrl: String? {
        camera.images?.large != nil ? camera.images?.large.content : camera.images?.small.content
    }
    
    var isDetail: Bool {
        camera.details != nil ? true : false
    }
    
    var details: [(ValueLabel, String)] {
        ValueLabel.allCases.compactMap { (value) -> (ValueLabel, String)? in
            switch value {
            case .megapixels:
                return (value, camera.details?.megapixels?.content) as? (ValueLabel, String)
            case .lsdScreenSize:
                return (value, camera.details?.lcdScreenSize?.content) as? (ValueLabel, String)
            case .memoryType:
                return (value, camera.details?.memoryType?.content) as? (ValueLabel, String)
            }
        }
    }
    
    required init(camera: Camera) {
        self.camera = camera
    }
}

