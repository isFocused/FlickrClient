//
//  SearchDetailViewCell.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 02.10.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class SearchDetailViewCell: UITableViewCell {

    static let reuseIdentifaer = "SearchDetailViewCell"
    var viewModel: SearchViewModelCellProtocol? { didSet { configure() } }
    
    let castomImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    let label: UILabel = {
        $0.text = "Label"
        return $0
    }(UILabel())
    
    let detailLabel: UILabel = {
        $0.text = "Detail"
        $0.font = UIFont.systemFont(ofSize: 15)
        return $0
    }(UILabel())
    
    let castomHorizontalStackView: CastomStackView = {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 5
        return $0
    }(CastomStackView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createCastomImageView()
        createCastomLabel()
        createDetailLabel()
        createCastomHorizontalStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        castomImageView.image = nil
        castomImageView.kf.cancelDownloadTask()
        castomHorizontalStackView.removeAllArrangedSubviews()
    }
    
    private func configure() {
        label.text = viewModel?.name
        castomHorizontalStackView.viewModel = viewModel?.detailModel
        guard let stringUrl = viewModel?.imageString,
              let url = URL(string: stringUrl) else
        {
            castomImageView.image = #imageLiteral(resourceName: "no image")
            return
        }
        castomImageView.kf.setImage(with: url)
    }
    
    private func createCastomImageView() {
        contentView.addSubview(castomImageView)
        
        castomImageView.snp.makeConstraints {
            $0.top.leading.equalTo(16)
            $0.bottom.lessThanOrEqualTo(-16)
            $0.size.equalTo(CGSize(width: 100, height: 100))
        }
        guard let stringUrl = viewModel?.imageString,
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
            $0.top.equalTo(16)
            $0.trailing.equalTo(-16)
            $0.leading.equalTo(castomImageView.snp.trailing).offset(16)
        }
    }
    
    private func createDetailLabel() {
        contentView.addSubview(detailLabel)
        
        detailLabel.snp.makeConstraints {
            $0.trailing.equalTo(-16)
            $0.top.equalTo(label.snp.bottom).offset(10)
            $0.leading.equalTo(castomImageView.snp.trailing).offset(16)
        }
    }
    
    private func createCastomHorizontalStackView() {
        contentView.addSubview(castomHorizontalStackView)
        
        castomHorizontalStackView.snp.makeConstraints {
            $0.trailing.equalTo(-16)
            $0.bottom.lessThanOrEqualTo(-16)
            $0.top.equalTo(detailLabel.snp.bottom).offset(16)
            $0.leading.equalTo(castomImageView.snp.trailing).offset(16)
        }
    }
}
