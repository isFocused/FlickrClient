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
    var detailModel: DetailViewModel { get }
    
    init(camera: Camera)
}

struct DetailViewModel {
    let titleMemoryType: String?
    let titleLcdScreenSize: String?
    let titleMegapixels: String?
}

class SearchViewModelCell: SearchViewModelCellProtocol {
    private let camera: Camera
    
    var name: String? {
        camera.name.content
    }
    
    var imageString: String? {
        camera.images?.large != nil ? camera.images?.large.content : camera.images?.small.content
    }
    
    var isDetails: Bool {
        camera.details != nil ? true : false
    }
    
    var detailModel: DetailViewModel {
        DetailViewModel(titleMemoryType: camera.details?.memoryType?.content,
                        titleLcdScreenSize: camera.details?.lcdScreenSize?.content,
                        titleMegapixels: camera.details?.megapixels?.content)
    }
    
    required init(camera: Camera) {
        self.camera = camera
    }
}

