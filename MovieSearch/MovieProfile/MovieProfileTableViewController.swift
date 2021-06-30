//
//  MovieProfileTableViewController.swift
//  MovieSearch
//
//  Created by Александр on 28.06.2021.
//  Copyright © 2021 Александр. All rights reserved.
//

import UIKit

class MovieProfileTableViewController: UITableViewController, MovieProfileViewProtocol {
    
    var movieId: Int?
    var presenter: MovieProfilePresenterProtocol?
    
    enum MovieProfileTableCellStringsNames { case imageUrl,title,overview,rating,genre,director,actors }
    var movieProfileTableCellStrings: [MovieProfileTableCellStringsNames:String] = [:]
    
    func setMovieProfileInfo(with info: MovieProfileInfo) {
        movieProfileTableCellStrings[.imageUrl] = info.imageUrl
        movieProfileTableCellStrings[.title] = info.title
        movieProfileTableCellStrings[.overview] = info.overview
        movieProfileTableCellStrings[.genre] = info.genre
        movieProfileTableCellStrings[.rating] = info.rating
        movieProfileTableCellStrings[.director] = info.director.joined(separator: ", ")
        movieProfileTableCellStrings[.actors] = info.actors.joined(separator: ", ")
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieProfilePresenter(view: self)
        presenter?.getMovieProfileInfo(for: movieId ?? 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.separatorStyle = .none
        let nib = UINib.init(nibName: "MovieProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MovieProfileTableViewCell")
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieProfileTableViewCell", for: indexPath) as! MovieProfileTableViewCell
        cell.imageURL = URL(string: movieProfileTableCellStrings[.imageUrl] ?? "")
        cell.movieTitleLabel.text = movieProfileTableCellStrings[.title]
        cell.movieRatingLabel.text = "Rating:\n\(movieProfileTableCellStrings[.rating] ?? "")"
        cell.movieOverviewTextView.text = "Overview:\n\(movieProfileTableCellStrings[.overview] ?? "")"
        cell.movieGenreLabel.text = "Genre:\n\(movieProfileTableCellStrings[.genre] ?? "")"
        cell.movieDirectorLabel.text = "Director:\n\(movieProfileTableCellStrings[.director] ?? "")"
        cell.movieActorsLabel.text = "Actors:\n\(movieProfileTableCellStrings[.actors] ?? "")"
        cell.translatesAutoresizingMaskIntoConstraints = false
        return cell
    }
    
}




