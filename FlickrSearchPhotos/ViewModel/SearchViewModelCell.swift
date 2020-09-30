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
    var imageString: String? { get }
    var isDetails: Bool { get }
    var details: [String: String] { get }
    
    init(camera: Camera)
}

class SearchViewModelCell: SearchViewModelCellProtocol {
    private let camera: Camera
    
    var name: String? {
        camera.name.content
    }
    
    var imageString: String? {
        if camera.images?.large != nil {
            return camera.images?.large.content
        } else {
            return camera.images?.small.content
        }
    }
    
    var isDetails: Bool {
        camera.details != nil ? true : false
    }
    
    var details: [String: String] {
        camera.details?.extractValues() ?? [String: String]()
    }
    
    required init(camera: Camera) {
        self.camera = camera
    }
}

