//
//  TabBarViewController.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 15.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private var firstViewController: UIViewController?
    private var secondViewController: UIViewController?
    
    init(firstViewController: UIViewController?, secondViewController: UIViewController?) {
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [firstViewController, secondViewController] as? [UIViewController]
        
        createTabBarItem(firstViewController,
                         title: "Search",
                         image: UIImage(systemName: "magnifyingglass"),
                         tag: 0)
        
        createTabBarItem(secondViewController,
                         title: "Popular photos",
                         image: UIImage(systemName: "star.fill"),
                         tag: 1)
    }
    
    
    private func createTabBarItem(_ viewController: UIViewController?, title: String, image: UIImage? = nil, tag: Int) {
        viewController?.tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
    }
}
