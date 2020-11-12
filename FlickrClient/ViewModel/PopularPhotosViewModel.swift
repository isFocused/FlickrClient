//
//  PopularPhotosViewModel.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 15.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

protocol PopularPhotosViewModelprotocol {
    var errorString: String? { get set }
    
    init(network: Networking, carentDate: CurentDateProtocol)
    
    func createCellViewModel(indexPath: IndexPath) -> PopularPhotoViewModelCellProtocol?
    func createCollageViewModel() -> CollageViewModel?
    func numberOfRowsInSection() -> Int
    func getPhotos(completion: @escaping (Bool) -> ())
    func getNewPhotos(indexPath: IndexPath, completion: @escaping ([URL]?) -> ())
}

class PopularPhotosViewModel: PopularPhotosViewModelprotocol {
    private var network: Networking?
    private var carentDate: CurentDateProtocol?
    private var photos: [Photo]?
    private var viewModelsCells: [PopularPhotoViewModelCellProtocol]?
    private var carentPage: Int
    private var pages: Int
    
    var errorString: String?
    
    var currentDateString: String {
        carentDate?.createStringDate() ?? ""
    }
    
    required init(network: Networking, carentDate: CurentDateProtocol) {
        self.network = network
        self.carentDate = carentDate
        viewModelsCells = []
        carentPage = 1
        pages = 0
    }
    
    func createCellViewModel(indexPath: IndexPath) -> PopularPhotoViewModelCellProtocol? {
        guard let photo = photos?[indexPath.item] else { return nil }
        let viewModelCell = PopularPhotoViewModelCell(photo: photo)
        viewModelsCells?.append(viewModelCell)
        return viewModelCell
    }
    
    func createCollageViewModel() -> CollageViewModel? {
        let urlsImages = viewModelsCells?.enumerated()
            .filter { $0.offset < 4 }
            .compactMap { $0.element.urlPhoto }
        
        return CollageViewModel(urlsPhotos: urlsImages)
    }
    
    func numberOfRowsInSection() -> Int {
        photos?.count ?? 10
    }
    
    func getPhotos(completion: @escaping (Bool) -> ()) {
        let endPoint = Endpoint(.getList, dateString: currentDateString, page: "\(carentPage)")
        network?.getPhotosData(endpoint: endPoint, completion: { [weak self] in
            switch $0 {
            case .success(let photoData):
                self?.pages = photoData.pages
                self?.photos = photoData.photo
                completion(true)
            case .failure(let error):
                self?.errorString = error.localizedDescription
                completion(false)
            }
        })
    }
    
    func getNewPhotos(indexPath: IndexPath, completion: @escaping ([URL]?) -> ()) {
        guard let photos = photos else { return }
        
        if photos.endIndex - 1 == indexPath.item && carentPage != pages {
            carentPage += 1
            let endPoint = Endpoint(.getList, dateString: currentDateString, page: "\(carentPage)")
            network?.getPhotosData(endpoint: endPoint, completion: { [weak self] in
                switch $0 {
                case .success(let photoData):
                    self?.photos?.append(contentsOf: photoData.photo)
                    let urlPhotos = photoData.photo.compactMap { URL(photo: $0) }
                    completion(urlPhotos)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
}
