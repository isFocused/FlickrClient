//
//  CastomStackView.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 01.10.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit

class CastomStackView: UIStackView {
    
    private enum ValueLabel: String {
        case megapixels = "Megapixels:"
        case lsdScreenSize = "Screen size:"
        case memoryType = "Memory type:"
    }
    
    var viewModel: DetailViewModel? { didSet { confegure() } }
    
    var megapixelsLabel: UILabel = {
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 10)
        return $0
    }(UILabel())
    var lsdScreenSizelabel: UILabel = {
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 10)
        return $0
    }(UILabel())
    
    var memoryTypelabel: UILabel = {
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 10)
        return $0
    }(UILabel())
    
    private func confegure() {
        megapixelsLabel.text = viewModel?.titleMegapixels
        lsdScreenSizelabel.text = viewModel?.titleLcdScreenSize
        memoryTypelabel.text = viewModel?.titleMemoryType
        
        if viewModel?.titleMegapixels != nil {
            addArrangedSubview(UIStackView(description: ValueLabel.megapixels.rawValue,
                                           label: megapixelsLabel))
        }
        
        if viewModel?.titleLcdScreenSize != nil {
            addArrangedSubview(UIStackView(description: ValueLabel.lsdScreenSize.rawValue,
                                           label: lsdScreenSizelabel))
        }
        
        if viewModel?.titleMemoryType != nil {
            addArrangedSubview(UIStackView(description: ValueLabel.memoryType.rawValue,
                                           label: memoryTypelabel))
        }
    }
}
