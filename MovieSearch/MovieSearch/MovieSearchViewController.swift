//
//  MovieSearchViewController.swift
//  MovieSearch
//
//  Created by Александр on 15.06.2021.
//  Copyright © 2021 Александр. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController {
    
    private var movieSearchView: MovieSearchView! {
        didSet {
            movieSearchView.translatesAutoresizingMaskIntoConstraints = false
            movieSearchView.searchViewResignationHandler = { [unowned self] in
                self.viewModel.queryMovie = self.movieSearchView.searchViewText
            }
            movieSearchView.loadNextPageHandler = { [unowned self] in
                self.viewModel.isLoading = true
            }
            movieSearchView.showHandler = { [unowned self] cellIndex in
                let vc = MovieProfileTableViewController()
                vc.title = self.viewModel?.movieSearchInfoList?[cellIndex].title
                vc.movieId = self.viewModel?.movieSearchInfoList?[cellIndex].id
                self.navigationController?.show(vc, sender: self)
            }
        }
    }

    private var viewModel: MovieSearchViewModel! {
        didSet {
            viewModel.bindMovieSearchInfoList = { [unowned self] result in
                self.movieSearchView.tableViewCellStrings = result
            }
            viewModel.startMovieListRefresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieSearchView = MovieSearchView()
        viewModel = MovieSearchViewModel()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.addSubview(movieSearchView)
    }
    
    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            movieSearchView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            movieSearchView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            movieSearchView.topAnchor.constraint(equalTo: guide.topAnchor),
            movieSearchView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
    
}


