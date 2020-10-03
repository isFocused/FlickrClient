//
//  UITabBarController+Extension.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 01.10.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit

extension UITabBarController {
    func setTabBarHidden(_ isHidden: Bool, animated: Bool, completion: (() -> Void)? = nil ) {
        if (tabBar.isHidden == isHidden) {
            completion?()
        }

        if !isHidden {
            tabBar.isHidden = false
        }

        let height = tabBar.frame.size.height
        let offsetY = view.frame.height - (isHidden ? 0 : height)
        let duration = (animated ? 0.25 : 0.0)

        let frame = CGRect(origin: CGPoint(x: tabBar.frame.minX, y: offsetY), size: tabBar.frame.size)
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear) {
            self.tabBar.frame = frame
        } completion: { _ in
            self.tabBar.isHidden = isHidden
            completion?()
        }
    }
}
