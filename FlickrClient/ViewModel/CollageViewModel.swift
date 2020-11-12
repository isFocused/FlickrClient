//
//  CollageViewModel.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 19.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

protocol CollageViewModelProtocol {
    var urlsPhotos: [URL]? { get }
    
    init?(urlsPhotos: [URL]?)
}

class CollageViewModel: CollageViewModelProtocol {
    var urlsPhotos: [URL]?
    
    required init(urlsPhotos: [URL]?) {
        self.urlsPhotos = urlsPhotos
    }
}
