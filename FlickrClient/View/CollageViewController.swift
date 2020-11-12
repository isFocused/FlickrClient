//
//  CollageViewController.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 18.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit
import SnapKit

class CollageViewController: UIViewController {
    
    var viewModel: CollageViewModelProtocol?
    var scrollView: CastomScrollView!
    
    lazy var haidGesure: UITapGestureRecognizer = {
        let gesure = UITapGestureRecognizer(target: self, action: #selector(hiddenNavigationBar))
        gesure.numberOfTapsRequired = 1
        return gesure
    }()
    
    private var isHiddenStatusBar = false
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        isHiddenStatusBar
    }
    
    override func loadView() {
        super.loadView()
        setupCastomScrollView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        title = "Collage"
        view.backgroundColor = .systemBackground
//        setupCastomScrollView()
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
    
    @objc func hiddenNavigationBar() {
        isHiddenStatusBar ?
            navigationController?.setNavigationBarHidden(false, animated: true) :
            navigationController?.setNavigationBarHidden(true, animated: true)
        
        isHiddenStatusBar = !isHiddenStatusBar
        
        UIView.animate(withDuration: 0.2) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    private func setupCastomScrollView() {
        scrollView = CastomScrollView(imagesUrl: viewModel?.urlsPhotos, frame: view.bounds)
        scrollView.addGestureRecognizer(haidGesure)
        haidGesure.require(toFail: scrollView.zoomingTap)
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.bottom.top.leading.trailing.equalToSuperview()
        }
    }
}
