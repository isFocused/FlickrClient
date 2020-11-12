//
//  Endpoint.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 05.10.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

struct Endpoint {
    private var myApi: API
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.flickr.com"
        components.path = "/services/rest/"
        components.queryItems = myApi.parametrs.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let url = components.url else { fatalError() }
        return url
    }
    
    init(_ method: API.Method, brand: String) {
        myApi = API(method: method)
        myApi.parametrs["brand"] = brand
    }
    
    init(_ method: API.Method, dateString: String, page: String) {
        myApi = API(method: method)
        myApi.parametrs["date"] = dateString
        myApi.parametrs["page"] = page
    }
}
