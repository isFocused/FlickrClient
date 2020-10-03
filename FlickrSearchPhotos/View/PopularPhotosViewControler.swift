//
//  PopularPhotosViewControler.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 15.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit
import Kingfisher

class PopularPhotosViewControler: UIViewController {
    
    var viewModel: PopularPhotosViewModelprotocol
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.register(PopularPhotoCollectionViewCell.self, forCellWithReuseIdentifier: PopularPhotoCollectionViewCell.reuseIdentifaer)
        return collectionView
    }()
    
    private lazy var collageButtonItem: UIBarButtonItem = {
        let barButtonitem = UIBarButtonItem(image: #imageLiteral(resourceName: "collage"),
                                            style: .done,
                                            target: self,
                                            action: #selector(pushCollageViewController))
        barButtonitem.isEnabled = false
        return barButtonitem
    }()
    
    private var spacing: CGFloat = 5
    private var numberOfItemsPerRow: CGFloat = 2
    private var spacingBetweenCells: CGFloat = 5
    
    init(viewModel: PopularPhotosViewModelprotocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = collageButtonItem
        collectionView.backgroundColor = .systemBackground
        
        createCollectionView()
        
        viewModel.getPhotos { [weak self] in
            DispatchQueue.main.async {
                self?.collageButtonItem.isEnabled = true
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func createCollectionView() {
        view.addSubview(collectionView)
        collectionView.fillView(view: view)
    }
    
    @objc private func pushCollageViewController() {
        let viewController = CollageViewController()
        viewController.viewModel = viewModel.createCollageViewModel()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PopularPhotosViewControler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularPhotoCollectionViewCell.reuseIdentifaer, for: indexPath) as! PopularPhotoCollectionViewCell
        cell.viewModel = viewModel.createCellViewModel(indexPath: indexPath)
        return cell
    }
}

extension PopularPhotosViewControler: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            viewModel.getNewPhotos(indexPath: indexPath) {
                ImagePrefetcher(urls: $0).start()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension PopularPhotosViewControler: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        
        let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
        let height = width
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
}
