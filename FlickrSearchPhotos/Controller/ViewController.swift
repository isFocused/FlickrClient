//
//  ViewController.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 03.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var network: Networking?
    private var cameras: [Camera]!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.reuseIdentifaer)
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: BaseTableViewCell.reuseIdentifaer)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network = NetworkManager()
        
        view.backgroundColor = .green
        
        network?.getResult(requestText: "sony") { [weak self] (resilt) in
            switch resilt {
            case .success(let camera):
                self?.cameras = camera
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cameras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifaer, for: indexPath) as! DetailTableViewCell
        
        return cell
    }
}

