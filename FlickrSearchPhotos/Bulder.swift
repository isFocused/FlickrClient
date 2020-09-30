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
        
        return TabBarViewController(firstViewController: createSearchViewController(network),
                             secondViewController: createPopularPhotosViewControler(network))
    }
    
    func createSearchViewController(_ network: Networking) -> UIViewController {
        let viewModel = SearchViewModel(network: network)
        let viewController = SearchViewController(viewModel: viewModel)
        
        return UINavigationController(rootViewController: viewController)
    }
    
    func createPopularPhotosViewControler(_ network: Networking) -> UIViewController {
        let viewModel = PopularPhotosViewModel(network: network)
        
        return UINavigationController(rootViewController: PopularPhotosViewControler(viewModel: viewModel))
    }
}
