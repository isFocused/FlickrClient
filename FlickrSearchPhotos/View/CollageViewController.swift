//
//  CollageViewController.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 18.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit
import Kingfisher

class CollageViewController: UIViewController {

    var viewModel: CollageViewModelProtocol!

    var scrollView: CastomScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView = CastomScrollView(image: getImageInCashe(), frame: view.bounds)
        view.backgroundColor = .blue
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCastomScrollView()
    }
    
    func setupCastomScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    func getImageInCashe() -> UIImage {
        var images = [UIImage]()
        viewModel.urlsPhotos.forEach {
            KingfisherManager.shared.retrieveImage(with: $0) { (result) in
                switch result {
                case .success(let casheImage): images.append(casheImage.image)
                default: break
                }
            }
        }
        
        return UIImage.collage(images: images, size: CGSize(width: 1280, height: 932))
    }
}
