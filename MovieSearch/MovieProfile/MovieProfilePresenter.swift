//
//  MovieProfilePresenter.swift
//  MovieSearch
//
//  Created by Александр on 24.06.2021.
//  Copyright © 2021 Александр. All rights reserved.
//

import UIKit

protocol MovieProfileViewProtocol: class {
    var movieId: Int? {get set}
    func setMovieProfileInfo(with info: MovieProfileInfo)
}

protocol MovieProfilePresenterProtocol {
    init(view: MovieProfileViewProtocol)
    func getMovieProfileInfo(for id: Int)
}

class MovieProfilePresenter: MovieProfilePresenterProtocol {
        
    private var view: MovieProfileViewProtocol
    private var movieProfileInfoProvider: MovieProfileInfoProvider?
    private var movieProfileInfo: MovieProfileInfo? {
        didSet {
            view.setMovieProfileInfo(with: movieProfileInfo!)
        }
    }
    
    required init(view: MovieProfileViewProtocol) {
        self.view = view
        movieProfileInfoProvider = MovieProfileInfoProvider()
        movieProfileInfoProvider?.movieProfileInfoProviderHandler = { [unowned self] result in
            self.movieProfileInfo = result
        }
    }
    
    func getMovieProfileInfo(for id: Int) {
        movieProfileInfoProvider?.getMovieProfileInfo(for: id)
    }
    
    
}

