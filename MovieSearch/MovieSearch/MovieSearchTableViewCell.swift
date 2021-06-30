//
//  MovieSearchTableViewCell.swift
//  MovieSearch
//
//  Created by Александр on 30.06.2021.
//  Copyright © 2021 Александр. All rights reserved.
//

import UIKit

class MovieSearchTableViewCell: UITableViewCell {

    var movieImageView: UIImageView! {
        didSet {
            movieImageView.translatesAutoresizingMaskIntoConstraints = false
            movieImageView.contentMode = .scaleAspectFit
            
        }
    }
    
    var movieInfoLabel: UILabel! {
        didSet {
            movieInfoLabel.translatesAutoresizingMaskIntoConstraints = false
            movieInfoLabel.numberOfLines = 0
            movieInfoLabel.textAlignment = .center
        }
    }
    
    var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.hidesWhenStopped = true
            spinner.style = .large
            spinner.color = .systemBlue
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        movieImageView = UIImageView()
        movieInfoLabel = UILabel()
        spinner = UIActivityIndicatorView()
        addSubview(movieImageView)
        addSubview(movieInfoLabel)
        movieImageView.addSubview(spinner)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: leadingAnchor ),
            movieImageView.topAnchor.constraint(equalTo: topAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: bottomAnchor ),
            movieImageView.widthAnchor.constraint(equalTo: movieInfoLabel.widthAnchor, multiplier: 0.25),
            movieImageView.heightAnchor.constraint(equalTo: movieImageView.widthAnchor, multiplier: 2.0),
            
            movieInfoLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor),
            movieInfoLabel.topAnchor.constraint(equalTo: topAnchor),
            movieInfoLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            movieInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: movieImageView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: movieImageView.centerYAnchor)
        ])
    }
    var imageURL: URL? {
        didSet {
            movieImageView?.image = nil
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
                            self?.movieImageView?.image = UIImage(data: imageData)
                        } else {
                            return
                        }
                    self?.spinner.stopAnimating()
                    }
            }
        }
    }

}
