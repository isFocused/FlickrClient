//
//  NetworkManager.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 03.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

protocol Networking {
    func getResult(requestText: String, completion: @escaping (Result<[Camera], BaseError>) -> ())
}

enum BaseError: Error {
    case invalidUrl
}

class NetworkManager: Networking {
    
    
    func getResult(requestText: String, completion: @escaping (Result<[Camera], BaseError>) -> ()) {
        let urlString = "https://www.flickr.com/services/rest/?method=flickr.cameras.getBrandModels&api_key=8c87235f93e8f0777e9c0d7a3c8224f3&brand=\(requestText)&format=json&nojsoncallback=1"
        
        if let url = URL(string: urlString) {
            getJsonData(url: url) {
                switch $0 {
                case .success(let data):
                    completion(.success(data.cameras.camera))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(.invalidUrl))
        }
    }
    
    private func getJsonData(url: URL, completion: @escaping (Result<JsonData, BaseError>) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error as? BaseError {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let newData = try JSONDecoder().decode(JsonData.self, from: data)
                    completion(.success(newData))
                } catch {
                    completion(.failure(error as! BaseError))
                }
            }
        }.resume()
    }
}
