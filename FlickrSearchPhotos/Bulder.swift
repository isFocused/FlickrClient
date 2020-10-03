//
//  Bulder.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 08.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit

class Bulder {
    func createRootViewController() -> UIViewController {
        let network = NetworkManager()
        let carentDate = CurentDateManager()
        
        return TabBarViewController(firstViewController: createSearchViewController(network),
                                    secondViewController: createPopularPhotosViewControler(network, carentDate: carentDate))
    }
    
    func createSearchViewController(_ network: Networking) -> UIViewController {
        let viewModel = SearchViewModel(network: network)
        let viewController = SearchViewController(viewModel: viewModel)
        
        return UINavigationController(rootViewController: viewController)
    }
    
    func createPopularPhotosViewControler(_ network: Networking, carentDate: CurentDateProtocol) -> UIViewController {
        let viewModel = PopularPhotosViewModel(network: network, carentDate: carentDate)
        
        return UINavigationController(rootViewController: PopularPhotosViewControler(viewModel: viewModel))
    }
}
