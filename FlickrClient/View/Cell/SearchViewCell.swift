//
//  SearchViewCell.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 02.10.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit
import SnapKit

class SearchViewCell: UITableViewCell {
    
    static let reuseIdentifaer = "SearchViewCell"
    var viewModel: SearchViewModelCellProtocol? { didSet { configure() } }
    
    let castomImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    let label: UILabel = {
        $0.text = "Label"
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private func configure() {
        createCastomImageView()
        createCastomLabel()
    }
    
    private func createCastomImageView() {
        contentView.addSubview(castomImageView)
        
        castomImageView.snp.makeConstraints {
            $0.leading.equalTo(16)
            $0.top.greaterThanOrEqualTo(16)
            $0.bottom.lessThanOrEqualTo(-16)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.size.equalTo(CGSize(width: 75, height: 75))
        }
        guard let stringUrl = viewModel?.imageStringUrl,
              let url = URL(string: stringUrl) else
        {
            castomImageView.image = #imageLiteral(resourceName: "no image")
            return
        }
        castomImageView.kf.setImage(with: url)
    }
    
    private func createCastomLabel() {
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(16)
            $0.trailing.equalTo(-16)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(castomImageView.snp.trailing).offset(16)
            $0.bottom.lessThanOrEqualTo(-16)
        }
        
        label.text = viewModel?.name
    }
}
