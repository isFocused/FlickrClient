//
//  SearchViewController.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 03.08.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    var viewModel: SearchViewModelProtocol
    
    lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.register(SearchViewCell.self, forCellReuseIdentifier: SearchViewCell.reuseIdentifaer)
        $0.register(SearchDetailViewCell.self, forCellReuseIdentifier: SearchDetailViewCell.reuseIdentifaer)
        return $0
    }(UITableView())
    
    lazy var searchController: UISearchController = {
        //        $0.hidesNavigationBarDuringPresentation = false
        $0.searchBar.delegate = self
        return $0
    }(UISearchController(searchResultsController: nil))
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        $0.isHidden = true
        $0.hidesWhenStopped = true
        $0.style = .medium
        return $0
    }(UIActivityIndicatorView())
    
    lazy var errorLabel: UILabel = {
        $0.numberOfLines = 0
        $0.isHidden = true
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
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
        setupNavigationBar()
    }
    
    private func updateUI() {
        viewModel.removeDataSourse()
        tableView.reloadData()
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
        if !errorLabel.isHidden {
            errorLabel.isHidden.toggle()
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.top.bottom.trailing.leading.equalToSuperview() }
    }
    
    private func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private func setupErrorLabel() {
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Search"
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModelCell = viewModel.createCellViewModel(indexPath: indexPath) else { return UITableViewCell() }
        
        switch viewModelCell.isDetail {
        case true:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SearchDetailViewCell.reuseIdentifaer, for: indexPath) as? SearchDetailViewCell {
                cell.viewModel = viewModelCell
                return cell
            }
        case false:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.reuseIdentifaer, for: indexPath) as? SearchViewCell {
                cell.viewModel = viewModelCell
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateUI()
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
                    self?.tableView.reloadData()
                    self?.errorLabel.text = self?.viewModel.errorString
                    self?.activityIndicatorView.stopAnimating()
                    self?.errorLabel.isHidden = false
                    self?.searchController.isActive = false
                }
            }
        }
    }
}
