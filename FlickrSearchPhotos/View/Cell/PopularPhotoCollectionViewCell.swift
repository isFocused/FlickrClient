//
//  PopularPhotoCollectionViewCell.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 15.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit

class PopularPhotoCollectionViewCell: UICollectionViewCell {
    
    var viewModel: PopularPhotoViewModelCellProtocol? {
        didSet {
            getImage()
        }
    }
    
    static let reuseIdentifaer = "SearchTableViewCell"
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.kf.cancelDownloadTask()
    }
    
    private func getImage() {
        imageView.image = nil
        imageView.kf.setImage(with: viewModel?.urlPhoto)
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.fillView(view: self)
    }
}
