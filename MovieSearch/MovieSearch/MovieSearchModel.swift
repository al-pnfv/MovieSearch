//
//  MovieSearchModel.swift
//  MovieSearch
//
//  Created by Александр on 22.06.2021.
//  Copyright © 2021 Александр. All rights reserved.
//

import Foundation

import TMDBSwift

struct MovieSearchInfo {
    var title: String
    var year: String
    var rating: Double
    var imageUrl: String
    var id: Int
}

class MovieSearchInfoListProvider {
    var movieSearchInfoListProviderHandler: ((_ movieList: [MovieSearchInfo]) -> Void)?
    
    func getMovieList(for name: String, on page: Int) {
        TMDBConfig.apikey = TMDBCustomConfig.apikey
        var movieList = [MovieSearchInfo]()
        let noValueDefault = TMDBCustomConfig.noValueDefault
        if name != "" {
            SearchMDB.movie(query: name, language: "EN", page: page, includeAdult: nil, year: nil, primaryReleaseYear: nil) { [unowned self] data, movies in
                guard let movies = movies else { return }
                movies.forEach { movieList.append(MovieSearchInfo(title: $0.title ?? noValueDefault,
                                                        year: $0.release_date ?? noValueDefault,
                                                        rating: $0.vote_average ?? 0.0,
                                                        imageUrl: TMDBCustomConfig.imageW500BaseUrl + ($0.poster_path ?? ""),
                                                        id: $0.id )) }
                self.movieSearchInfoListProviderHandler?(movieList)
            }
        } else {
            DiscoverMovieMDB.discoverMovies(params: [.language("EN"), .page(page), .sort_by("popularity.desc")]) { [unowned self] data, movies in
                guard let movies = movies else { return }
                movies.forEach { movieList.append(MovieSearchInfo(title: $0.title ?? noValueDefault,
                                                        year: $0.release_date ?? noValueDefault,
                                                        rating: $0.vote_average ?? 0.0,
                                                        imageUrl: TMDBCustomConfig.imageW500BaseUrl + ($0.poster_path ?? ""),
                                                        id: $0.id )) }
                self.movieSearchInfoListProviderHandler?(movieList)
            }
        }
    }
}
