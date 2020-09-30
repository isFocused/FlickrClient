//
//  SearchTableViewCell.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 03.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {

    var viewModel: SearchViewModelCellProtocol? {
        didSet {
            configure()
        }
    }
    
    static let reuseIdentifaer = "SearchTableViewCell"
    
    var castomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    func configure() {
        createCastomImageView()
        createTitleLabel()
        
        titleLabel.text = viewModel?.name
        getImage(urlString: viewModel?.imageString)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        castomImageView.image = nil
        castomImageView.kf.cancelDownloadTask()
    }
    
    private func getImage(urlString: String?) {
        guard let stringUrl = urlString, let url = URL(string: stringUrl) else {
            castomImageView.image = #imageLiteral(resourceName: "no image")
            return
        }
        
        castomImageView.kf.setImage(with: url)
    }
    
    private func createCastomImageView() {
        addSubview(castomImageView)

        castomImageView.setConstraints(topAnchor: self.topAnchor, leadingAnchor: self.leadingAnchor, bottomAnchor: self.bottomAnchor, paddingTop: 16, paddingLeading: 16, paddingBottom: 16, width: 75, height: 75)
    }
    
    private func createTitleLabel() {
        addSubview(titleLabel)
        
        titleLabel.setConstraints(leadingAnchor: castomImageView.trailingAnchor, trailingAnchor: self.trailingAnchor, paddingLeading: 16, paddingTrailing: 16)
        titleLabel.setCenterY(view: self)
    }
}
