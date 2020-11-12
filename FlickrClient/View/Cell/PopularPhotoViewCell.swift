//
//  PopularPhotoViewCell.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 15.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit

class PopularPhotoViewCell: UICollectionViewCell {
    
    var viewModel: PopularPhotoViewModelCellProtocol? { didSet { getImage() } }
    
    static let reuseIdentifaer = "SearchTableViewCell"
    
    var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    var spiner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView()
        spin.startAnimating()
        spin.hidesWhenStopped = true
        spin.style = .medium
        spin.translatesAutoresizingMaskIntoConstraints = false
        return spin
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        cetupSpin()
        backgroundColor = .gray
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
        imageView.kf.setImage(with: viewModel?.urlPhoto,
                              completionHandler: { _ in
                                self.spiner.stopAnimating()
                              })
        
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.bottom.top.trailing.leading.equalTo(contentView)
        }
    }
    
    private func cetupSpin() {
        imageView.addSubview(spiner)
        spiner.snp.makeConstraints {
            $0.centerX.centerY.equalTo(contentView)
        }
    }
}
