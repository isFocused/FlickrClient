//
//  SearchViewController.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 03.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var viewModel: SearchViewModelProtocol
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.register(SearchDetailTableViewCell.self, forCellReuseIdentifier: SearchDetailTableViewCell.reuseIdentifaer)
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifaer)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.delegate = self
        controller.searchBar.searchBarStyle = .prominent
        return controller
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        return activityIndicator
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActivityIndicatorView()
        setupErrorLabel()
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Search"
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.fillView(view: view)
    }
    
    private func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.setCenterConstraints(view: view)
    }
    
    private func setupErrorLabel() {
        view.addSubview(errorLabel)
        
        errorLabel.setCenterConstraints(view: view)
        errorLabel.setConstraints(leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingLeading: 16, paddingTrailing: 16)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModelCell = viewModel.createCellViewModel(indexPath: indexPath) else { return UITableViewCell() }
        
        if viewModelCell.isDetails {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchDetailTableViewCell.reuseIdentifaer, for: indexPath) as! SearchDetailTableViewCell
            cell.viewModel = viewModelCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifaer, for: indexPath) as! SearchTableViewCell
            cell.viewModel = viewModelCell

            return cell
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.reload {
            tableView.reloadData()
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            errorLabel.isHidden = true
        }
        
        viewModel.search(requestText: searchBar.text) { [weak self] in
            switch $0 {
            case true:
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.activityIndicatorView.stopAnimating()
                    self?.searchController.isActive = false
                }
            case false:
                DispatchQueue.main.async {
                    self?.errorLabel.text = self?.viewModel.errorString
                    self?.activityIndicatorView.stopAnimating()
                    self?.errorLabel.isHidden = false
                    self?.searchController.isActive = false
                }
            }
        }
    }
}

