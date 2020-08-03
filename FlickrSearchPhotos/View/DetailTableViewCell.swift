//
//  DetailTableViewCell.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 03.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    static let reuseIdentifaer = "DetailTableViewCell"
    
    var castomImageView: UIImageView = {
       UIImageView()
    }()
    
    var titleLabel: UILabel = {
        UILabel()
    }()
    
    var detailsLabel: UILabel = {
        UILabel()
    }()
    
    func configure(camera: Camera) {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        castomImageView.image = nil
    }
}
