//
//  UIStackView+Extension.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 01.10.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit

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

extension UIStackView {
    convenience init(description: String?, label: UILabel) {
        let oneLabel = UILabel()
        oneLabel.text = description
        oneLabel.font = UIFont.systemFont(ofSize: 10)
        
        self.init(arrangedSubviews: [oneLabel, label])
        axis = .horizontal
        distribution = .fill
        spacing = 10
    }
}
