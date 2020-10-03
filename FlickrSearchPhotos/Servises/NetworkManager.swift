//
//  NetworkManager.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 03.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

protocol Networking {
    func getSearchResult(requestText: String, completion: @escaping (Result<[Camera], Error>) -> ())
    func getPhotosData(page: Int, dateString: String?, completion: @escaping (Result<Photos, Error>) -> ())
}

class NetworkManager: Networking {
    
    func getSearchResult(requestText: String, completion: @escaping (Result<[Camera], Error>) -> ()) {
        let urlString = "https://www.flickr.com/services/rest/?method=flickr.cameras.getBrandModels&api_key=8c87235f93e8f0777e9c0d7a3c8224f3&brand=\(requestText)&format=json&nojsoncallback=1"
        
        if let url = URL(string: urlString) {
            getJsonData(url: url, JsonData.self) {
                switch $0 {
                case .success(let data):
                    completion(.success(data.cameras.camera))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
    }
    
    func getPhotosData(page: Int, dateString: String?, completion: @escaping (Result<Photos, Error>) -> ()) {
        guard let dateString = dateString else { return }
        let urlSring = "https://www.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=2b479eb67e7160d6f00edc43e766b02a&date=\(dateString)&per_page=20&page=\(page)&format=json&nojsoncallback=1"
        
        if let url = URL(string: urlSring) {
            getJsonData(url: url, JsonPhotoData.self) {
                switch $0 {
                case .success(let data):
                    completion(.success(data.photos))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func getJsonData<T: Codable>(url: URL, _ type: T.Type, completion: @escaping (Result<T, Error>) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let newData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(newData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func createUrl() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.flickr.com"
        components.path = "/services/rest"
        
        return components.url
    }
}
