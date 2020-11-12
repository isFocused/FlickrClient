//
//  API.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 05.10.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

struct API {
    typealias Parametrs = [String: String]
    
    enum Method: String {
        case getBrandModels = "flickr.cameras.getBrandModels"
        case getList = "flickr.interestingness.getList"
    }
    
    private let apiKey = "2b479eb67e7160d6f00edc43e766b02a"
    private let format = "json"
    private let noJsonCallback = "1"
    private let perPage = "20"
    private let method: Method
    
    var parametrs: Parametrs
    
    init(method: Method) {
        self.method = method
        
        switch method {
        case .getBrandModels:
            parametrs = [
                "method": method.rawValue,
                "api_key": apiKey,
                "format": format,
                "nojsoncallback": noJsonCallback
            ]
        case .getList:
            parametrs = [
                "method": method.rawValue,
                "api_key": apiKey,
                "format": format,
                "nojsoncallback": noJsonCallback,
                "per_page": perPage
            ]
        }
    }
}
