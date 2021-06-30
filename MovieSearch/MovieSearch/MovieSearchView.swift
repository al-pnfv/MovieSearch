//
//  MovieSearchView.swift
//  MovieSearch
//
//  Created by Александр on 22.06.2021.
//  Copyright © 2021 Александр. All rights reserved.
//

import UIKit


class MovieSearchView: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    var tableViewCellStrings: [[String:String]]? {
        didSet {
            spinner.stopAnimating()
            if tableViewCellStrings!.count <= 20 {
                tableView.scrollToTop()
            }
            tableView.reloadData()

        }
    }

    
    private var searchView: UITextField! {
        didSet {
            searchView.translatesAutoresizingMaskIntoConstraints = false
            searchView.placeholder = "Enter movie name"
            searchView.borderStyle = .roundedRect
            searchView.delegate = self
        }
    }
    
    private var tableView: UITableView! {
        didSet {
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicCell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(MovieSearchTableViewCell.self, forCellReuseIdentifier: "MovieSearchTableViewCell")

        }
    }
    
    private var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            spinner.hidesWhenStopped = true
            spinner.style = .large
            spinner.color = .systemBlue
        }
    }
    
    private let innerPadding: CGFloat = 25.0
    private let outerPadding: CGFloat = 25.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        searchView = UITextField()
        tableView = UITableView()
        spinner = UIActivityIndicatorView()
        addSubview(searchView)
        addSubview(tableView)
        tableView.addSubview(spinner)
    }
    
    private func setupConstraints() {
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: outerPadding, leading: outerPadding, bottom: outerPadding, trailing: outerPadding)
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            searchView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: innerPadding),
            
            tableView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
    
    var searchViewText: String {
        return searchView.text ?? ""
    }
    var searchViewResignationHandler: (() -> Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        searchViewResignationHandler?()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchView.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCellStrings?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSearchTableViewCell", for: indexPath) as! MovieSearchTableViewCell
        let title = tableViewCellStrings?[indexPath.item]["title"] ?? ""
        let year = tableViewCellStrings?[indexPath.item]["year"] ?? ""
        let rating = tableViewCellStrings?[indexPath.item]["rating"] ?? ""
        let imageUrl = tableViewCellStrings?[indexPath.item]["imageUrl"] ?? ""
        cell.movieInfoLabel?.text = " \"\(title)\",\n release date: \(year),\n rating: \(rating)"
        cell.imageURL = URL(string: imageUrl)
        return cell
    }
        
    
    var loadNextPageHandler: (() -> Void)?
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if (offsetY > contentHeight - scrollView.frame.height * 0.9) {
            loadNextPageHandler?()
        }
    }
    
    var showHandler: ((_ cellIndex: Int) -> Void)?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showHandler?(indexPath.item)
    }
    
    

}



