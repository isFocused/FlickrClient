//
//  URL+Extension.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 08.11.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

extension URL {
    init?(photo: Photo) {
        self.init(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_z.jpg")
    }
}
