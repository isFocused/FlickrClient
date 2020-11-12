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
        $0.font = .systemFont(ofSize: 17)
        return $0
    }(UILabel())
    
    var textView: UITextView = {
        $0.isScrollEnabled = false
        $0.isEditable = false
        $0.backgroundColor = .clear
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = 0
        return $0
    }(UITextView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createCastomImageView()
        createCastomLabel()
        createTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        castomImageView.image = nil
        castomImageView.kf.cancelDownloadTask()
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        label.text = viewModel.name
        convertFromText()
        
        guard let stringUrl = viewModel.imageStringUrl else { return }
        guard let url = URL(string: stringUrl) else { return }
        castomImageView.kf.setImage(with: url)
    }
    
    private func createCastomImageView() {
        contentView.addSubview(castomImageView)
        
        castomImageView.snp.makeConstraints {
            $0.top.leading.equalTo(16)
            $0.bottom.lessThanOrEqualTo(-16)
            $0.size.equalTo(CGSize(width: 100, height: 100))
            castomImageView.image = #imageLiteral(resourceName: "no image")
        }
    }
    
    private func createCastomLabel() {
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.trailing.equalTo(-16)
            $0.leading.equalTo(castomImageView.snp.trailing).offset(16)
        }
    }
    
    private func createTextView() {
        contentView.addSubview(textView)
        
        textView.snp.makeConstraints {
            $0.trailing.equalTo(-16)
            $0.bottom.lessThanOrEqualTo(-16)
            $0.top.equalTo(label.snp.bottom).offset(5)
            $0.leading.equalTo(castomImageView.snp.trailing).offset(16)
        }
    }
    
    private func convertFromText() {
        let attributesTextView = NSMutableAttributedString()
        attributesTextView.append(NSAttributedString(string: "Detail\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 15), .foregroundColor: UIColor.label]))
        
        var attributes = [NSAttributedString.Key: Any]()
        attributes[.font] = UIFont.systemFont(ofSize: 12)
        attributes[.foregroundColor] = UIColor.label
        
        if let viewModel = viewModel {
            let strings = viewModel.details.map { detail -> String in
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.headIndent = (detail.0.rawValue as NSString).size(withAttributes: attributes).width
                attributes[.paragraphStyle] = paragraphStyle
                
                return detail.0.rawValue + detail.1
            }
            
            let string = strings.joined(separator: "\n")
            attributesTextView.append(NSAttributedString(string: string, attributes: attributes))
            textView.attributedText = attributesTextView
        }
    }
}
