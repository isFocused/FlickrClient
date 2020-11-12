//
//  SearchViewModel.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 08.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

protocol SearchViewModelProtocol {
    var errorString: String? { get set }
    
    init(network: Networking)
    
    func numberOfRowsInSection() -> Int
    func createCellViewModel(indexPath: IndexPath) -> SearchViewModelCellProtocol?
    func search(requestText: String?, completion: @escaping (Bool) -> ())
    func removeDataSourse()
}

class SearchViewModel: SearchViewModelProtocol {
    
    var errorString: String?
    
    private var network: Networking?
    private var cameras: [Camera]?
    
    required init(network: Networking) {
        self.network = network
    }
    
    func search(requestText: String?, completion: @escaping (Bool) -> ()) {
        guard let text = requestText else { return }
        network?.getSearchResult(endpoint: Endpoint(.getBrandModels, brand: text), completion: { [weak self] in
            switch $0 {
            case .failure(let error):
                self?.errorString = error.localizedDescription
                completion(false)
            case .success(let value):
                self?.cameras = value
                completion(true)
            }
        })
    }
    
    func createCellViewModel(indexPath: IndexPath) -> SearchViewModelCellProtocol? {
        guard let camera = cameras?[indexPath.row] else { return nil }
        
        return SearchViewModelCell(camera: camera)
    }
    
    func numberOfRowsInSection() -> Int {
        cameras?.count ?? 0
    }
    
    func removeDataSourse() {
        cameras?.removeAll()
    }
}
