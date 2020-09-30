//
//  SearchDetailTableViewCell.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 03.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit
import Kingfisher

class SearchDetailTableViewCell: UITableViewCell {
    
    var viewModel: SearchViewModelCellProtocol? {
        didSet {
            configure()
        }
    }
    
    static let reuseIdentifaer = "SearchDetailTableViewCell"
    
    private lazy var castomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let defaultLabel = UILabel()
        defaultLabel.text = "Details"
        defaultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return defaultLabel
    }()
    
    private lazy var verticalLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        castomImageView.image = nil
        verticalLabelStackView.removeAllArrangedSubviews()
        castomImageView.kf.cancelDownloadTask()
    }
    
    private func configure() {
        titleLabel.text = viewModel?.name
        getImage(urlString: viewModel?.imageString)
        
        createCastomImageView()
        createTitleLabel()
        createDetailLabel()
        
        guard let dict = viewModel?.details else { return }
        createStackViewLabel(distionaryValues: dict)
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
        
        castomImageView.setConstraints(topAnchor: self.topAnchor,
                                       leadingAnchor: self.leadingAnchor,
                                       bottomAnchor: self.bottomAnchor,
                                       paddingTop: 16,
                                       paddingLeading: 16,
                                       paddingBottom: 16,
                                       width: 125,
                                       height: 125)
    }
    
    private func createTitleLabel() {
        addSubview(titleLabel)
        
        titleLabel.setConstraints(topAnchor: self.topAnchor,
                                  leadingAnchor: castomImageView.trailingAnchor,
                                  trailingAnchor: self.trailingAnchor,
                                  paddingTop: 16,
                                  paddingLeading: 16,
                                  paddingTrailing: 16,
                                  height: 20.5)
    }
    
    private func createDetailLabel() {
        addSubview(detailLabel)
        
        detailLabel.setConstraints(topAnchor: titleLabel.bottomAnchor,
                                   leadingAnchor: castomImageView.trailingAnchor,
                                   paddingTop: 5,
                                   paddingLeading: 16,
                                   height: 20.5)
    }
    
    private func createStackViewLabel(distionaryValues: [String: String]) {
        distionaryValues.forEach {
            let horizontalStack = createHorizontelLabelStackView(first: createLabel(from: $0),
                                                                 second: createLabel(from: $1))
            verticalLabelStackView.addArrangedSubview(horizontalStack)
            
        }

        addSubview(verticalLabelStackView)
        
        verticalLabelStackView.setConstraints(topAnchor: detailLabel.bottomAnchor,
                                              leadingAnchor: castomImageView.trailingAnchor,
                                              trailingAnchor: self.trailingAnchor,
                                              paddingTop: 16, paddingLeading: 16,
                                              paddingTrailing: 16)
    }
    
    private func createHorizontelLabelStackView(first: UIView, second: UIView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [first, second])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }
    
    private func createLabel(from title: String) -> UILabel {
        let defaultLabel = UILabel()
        defaultLabel.text = title
//        defaultLabel.numberOfLines = 0
        defaultLabel.adjustsFontSizeToFitWidth = true
        defaultLabel.minimumScaleFactor = 0.5
        defaultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return defaultLabel
    }
}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
