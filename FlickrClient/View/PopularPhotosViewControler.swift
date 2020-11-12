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
        $0.dataSource = self
        $0.delegate = self
        $0.prefetchDataSource = self
        $0.backgroundColor = .systemBackground
        $0.register(PopularPhotoViewCell.self, forCellWithReuseIdentifier: PopularPhotoViewCell.reuseIdentifaer)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    private lazy var errorLabel: UILabel = {
        $0.numberOfLines = 0
        $0.isHidden = true
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var collageButtonItem: UIBarButtonItem = {
        $0.isEnabled = false
        return $0
    }(UIBarButtonItem(image: #imageLiteral(resourceName: "collage"), style: .done, target: self, action: #selector(pushCollageViewController)))
    
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
        setupNavigationBar()
        createCollectionView()
        setupErrorLabel()
        viewModel.getPhotos { [weak self] in
            switch $0 {
            case true:
                DispatchQueue.main.async {
                    self?.collageButtonItem.isEnabled = true
                    self?.collectionView.reloadData()
                }
            case false:
                DispatchQueue.main.async {
                    self?.errorLabel.text = self?.viewModel.errorString
                    self?.errorLabel.isHidden = false
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = collageButtonItem
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Popular photos"
    }
    
    private func createCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.bottom.top.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupErrorLabel() {
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
        }
    }
    
    @objc private func pushCollageViewController() {
        let viewController = CollageViewController()
        viewController.viewModel = viewModel.createCollageViewModel()
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

extension PopularPhotosViewControler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularPhotoViewCell.reuseIdentifaer, for: indexPath) as! PopularPhotoViewCell
        cell.viewModel = viewModel.createCellViewModel(indexPath: indexPath)
        return cell
    }
}

extension PopularPhotosViewControler: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            viewModel.getNewPhotos(indexPath: indexPath) {
                guard let urls = $0 else { return }
                ImagePrefetcher(urls: urls).start()
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
