//
//  MovieProfileTableViewCell.swift
//  MovieSearch
//
//  Created by Александр on 28.06.2021.
//  Copyright © 2021 Александр. All rights reserved.
//

import UIKit

class MovieProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var movieRatingLabel: UILabel!
    
    @IBOutlet weak var movieOverviewTextView: UITextView!
    
    @IBOutlet weak var movieGenreLabel: UILabel!
    
    @IBOutlet weak var movieDirectorLabel: UILabel!
    
    @IBOutlet weak var movieActorsLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageURL: URL? {
        didSet {
            movieImageView.image = nil
            fetchImage()
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url.imageURL)
                    DispatchQueue.main.async {
                        if let imageData = urlContents, url == self?.imageURL {
                            self?.movieImageView.image = UIImage(data: imageData)
                        } else {
                            return
                        }
                    self?.spinner.stopAnimating()
                    }
            }
        }
    }
    
}
