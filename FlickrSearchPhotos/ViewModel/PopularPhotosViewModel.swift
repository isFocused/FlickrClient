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
    func numberOfRowsInSection() -> Int
    func getPhotos(completion: @escaping () -> ())
    func getNewPhotos(indexPath: IndexPath, completion: @escaping ([URL]?) -> ())
    func createCollageViewModel() -> CollageViewModel
}

class PopularPhotosViewModel: PopularPhotosViewModelprotocol {
    private var network: Networking?
    private var carentDate: CurentDateProtocol?
    private var photos: [Photo]?
    private var viewModelsCells: [PopularPhotoViewModelCellProtocol]
    private var carentPage: Int
    
    var errorString: String?
    
    var currentDateString: String {
        carentDate?.createStringDate() ?? ""
    }
    
    required init(network: Networking, carentDate: CurentDateProtocol) {
        self.network = network
        self.carentDate = carentDate
        carentPage = 1
        viewModelsCells = []
    }
    
    func createCellViewModel(indexPath: IndexPath) -> PopularPhotoViewModelCellProtocol? {
        guard let photo = photos?[indexPath.item] else { return nil }
        let viewModelCell = PopularPhotoViewModelCell(photo: photo)
        viewModelsCells.append(viewModelCell)
        return viewModelCell
    }
    
    func numberOfRowsInSection() -> Int {
        photos?.count ?? 0
    }
    
    func getPhotos(completion: @escaping () -> ()) {
        let endPoint = Endpoint(.getList, dateString: currentDateString, page: "\(carentPage)")
        network?.getPhotosData(endpoint: endPoint, completion: { [weak self] in
            switch $0 {
            case .success(let photoData):
                self?.carentPage = photoData.page
                self?.photos = photoData.photo
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func getNewPhotos(indexPath: IndexPath, completion: @escaping ([URL]?) -> ()) {
        
        if photos!.count - 1 != indexPath.item {
            return
        } else {
            let endPoint = Endpoint(.getList, dateString: currentDateString, page: "\(carentPage + 1)")
            network?.getPhotosData(endpoint: endPoint, completion: { [weak self] in
                switch $0 {
                case .success(let photoData):
                    self?.carentPage = photoData.page
                    self?.photos?.append(contentsOf: photoData.photo ?? [])
                    let urlPhotos = photoData.photo?.map { URL(string: "https://farm\($0.farm).staticflickr.com/\($0.server)/\($0.id)_\($0.secret)_z.jpg")! }
                    completion(urlPhotos)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
    
    func createCollageViewModel() -> CollageViewModel {
        var urlsImages = [URL]()
        viewModelsCells.enumerated().forEach {
            if $0.offset < 4 {
                urlsImages.append($0.element.urlPhoto)
            }
        }
        return CollageViewModel(urlsPhotos: urlsImages)
    }
}
