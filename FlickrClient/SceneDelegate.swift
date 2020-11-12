//
//  SceneDelegate.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 03.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var bulder: BulderProtol?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        bulder = Bulder()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = bulder?.createRootViewController()
        
        window?.makeKeyAndVisible()
    }
}

