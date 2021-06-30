//
//  MovieProfileModel.swift
//  MovieSearch
//
//  Created by Александр on 24.06.2021.
//  Copyright © 2021 Александр. All rights reserved.
//

import Foundation

import TMDBSwift

struct MovieProfileInfo {
    var imageUrl: String
    var title: String
    var rating: String
    var overview: String
    var genre: String
    var director: [String]
    var actors: [String]
}


class MovieProfileInfoProvider {
    
    var movieProfileInfoProviderHandler: ((_ movieList: MovieProfileInfo) -> Void)?
    
    func getMovieProfileInfo(for id: Int) {
        TMDBConfig.apikey = TMDBCustomConfig.apikey
        let noValueDefault = TMDBCustomConfig.noValueDefault
        MovieMDB.movie(movieID: id) { [unowned self] apiReturn, movie in
            MovieMDB.credits(movieID: id) { [unowned self] apiReturn, credits in
                let movieProfileInfo = MovieProfileInfo(imageUrl: TMDBCustomConfig.imageOriginalBaseUrl + (movie?.poster_path ?? ""),
                                                        title: movie?.title ?? noValueDefault,
                                                        rating: String(movie?.vote_average ?? 0.0),
                                                        overview: movie?.overview ?? noValueDefault,
                                                        genre: movie?.genres[0].name ?? noValueDefault,
                                                        director: credits?.crew.filter{ $0.job == "Director" }.map{ $0.name } ?? [""],
                                                        actors: credits?.cast.map { $0.name ?? ""} ?? [""])
                self.movieProfileInfoProviderHandler?(movieProfileInfo)
            }
        }
    }
}

