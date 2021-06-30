//
//  MovieSearchViewModel.swift
//  MovieSearch
//
//  Created by Александр on 22.06.2021.
//  Copyright © 2021 Александр. All rights reserved.
//

import UIKit

class MovieSearchViewModel {
    
    var bindMovieSearchInfoList: ((_ movieSearchInfoListResult: [[String:String]]) -> Void)?
    
    var queryMovie: String! {
        didSet {
            page = nil
        }
    }
    
    var isLoading = false
    
    private var page: Int!
    
    private var movieSearchInfoListProvider: MovieSearchInfoListProvider? {
        didSet {
            movieSearchInfoListProvider?.movieSearchInfoListProviderHandler = { [weak self] movies in
                if self?.page == 1 {
                    self?.movieSearchInfoList = movies
                    
                } else if self?.isLoading ?? false {
                    self?.isLoading = false
                    self?.movieSearchInfoList?.append(contentsOf: movies)
                }
                self?.page += 1
            }
        }
    }
    
    private (set) var movieSearchInfoList: [MovieSearchInfo]? {
        didSet {
            let movieSearchInfoListStrings: [[String:String]] = movieSearchInfoList!.map {
                ["title": $0.title, "year": $0.year, "rating": String($0.rating), "imageUrl": $0.imageUrl]
            }
            bindMovieSearchInfoList?(movieSearchInfoListStrings)
        }
    }
    
    private var refreshTimer: Timer!
    
    func startMovieListRefresh() {
        if refreshTimer == nil {
            refreshTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshMovieSearchInfoList), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func refreshMovieSearchInfoList() {
        if movieSearchInfoListProvider == nil {
            movieSearchInfoListProvider = MovieSearchInfoListProvider()
        }
        if page == nil {
            page = 1
            movieSearchInfoListProvider?.getMovieList(for: queryMovie ?? "", on: page)
        } else if isLoading {
            movieSearchInfoListProvider?.getMovieList(for: queryMovie ?? "", on: page)
        }
    }
    
}
