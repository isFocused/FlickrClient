//
//  PopularPhotoViewModelCell.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 15.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

protocol PopularPhotoViewModelCellProtocol {
    var urlPhoto: URL { get }
    init(photo: Photo)
}

class PopularPhotoViewModelCell: PopularPhotoViewModelCellProtocol {
    private let photo: Photo
    
    var urlPhoto: URL {
        URL(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_z.jpg")!
    }
    
    required init(photo: Photo) {
        self.photo = photo
    }
}
