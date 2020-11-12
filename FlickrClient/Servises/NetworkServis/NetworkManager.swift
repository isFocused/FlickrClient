//
//  NetworkManager.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 03.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

protocol Networking {
    func getSearchResult(endpoint: Endpoint, completion: @escaping (Result<[Camera], Error>) -> ())
    func getPhotosData(endpoint: Endpoint, completion: @escaping (Result<Photos, Error>) -> ())
}

class NetworkManager: Networking {
    
    func getSearchResult(endpoint: Endpoint, completion: @escaping (Result<[Camera], Error>) -> ()) {
        print(endpoint.url)
        getJsonData(url: endpoint.url, JsonSearch.self) {
            switch $0 {
            case .success(let data):
                completion(.success(data.cameras.camera))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPhotosData(endpoint: Endpoint, completion: @escaping (Result<Photos, Error>) -> ()) {
        getJsonData(url: endpoint.url, JsonPhotoData.self) {
            switch $0 {
            case .success(let data):
                completion(.success(data.photos))
            case .failure(let error):
                completion(.failure(error))
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
}
