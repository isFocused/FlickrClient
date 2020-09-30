//
//  PopularPhotosViewModel.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 15.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import Foundation

protocol PopularPhotosViewModelprotocol {
    var currentDateString: String { get }
    
    init(network: Networking)
    
    func createCellViewModel(indexPath: IndexPath) -> PopularPhotoViewModelCellProtocol?
    func numberOfRowsInSection() -> Int
    func getPhotos(completion: @escaping () -> ())
    func getNewPhotos(indexPath: IndexPath, completion: @escaping ([URL]) -> ())
    func createCollageViewModel() -> CollageViewModel
}

class PopularPhotosViewModel: PopularPhotosViewModelprotocol {
    private var network: Networking?
    private var photos: [Photo]?
    private var viewModelsCells: [PopularPhotoViewModelCellProtocol]
    private var pages: Int
    private var carentPage: Int
    
    var currentDateString: String {
        createDateString()
    }
    
    required init(network: Networking) {
        self.network = network
        pages = 0
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
        photos?.count ?? 8
    }
    
    func getPhotos(completion: @escaping () -> ()) {
        network?.getPhotosData(page: carentPage, dateString: currentDateString, completion: { [weak self] in
            switch $0 {
            case .success(let photoData):
                self?.pages = photoData.pages
                self?.carentPage = photoData.page
                self?.photos = photoData.photo
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func getNewPhotos(indexPath: IndexPath, completion: @escaping ([URL]) -> ()) {
        
        if photos!.count - 1 != indexPath.item {
            return
        } else {
            network?.getPhotosData(page: carentPage + 1, dateString: currentDateString, completion: { [weak self] in
                switch $0 {
                case .success(let photoData):
                    self?.pages = photoData.pages
                    self?.carentPage = photoData.page
                    self?.photos?.append(contentsOf: photoData.photo ?? [])
                    var urls = [URL]()
                    photoData.photo?.forEach {
                        urls.append(URL(string: "https://farm\($0.farm).staticflickr.com/\($0.server)/\($0.id)_\($0.secret)_z.jpg")!)
                    }
                    completion(urls)
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
    
    private func createDateString() -> String {
        let calendar = Calendar.current
        
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()) else { return "" }
        let components = calendar.dateComponents([.year, .month, .day], from: yesterday)
        guard let year = components.year, let month = components.month, let day = components.day else {
                return ""
        }
        
        if month < 10 {
            return "\(String(describing: year))-0\(String(describing: month))-\(String(describing: day - 1))"
        } else {
             return "\(String(describing: year))-\(String(describing: month))-\(String(describing: day))"
        }
    }
}
