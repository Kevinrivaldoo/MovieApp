//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Kevin Rivaldo  on 18/03/22.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    
    var movie: Movie? {
        didSet {
            if let movie = movie {
                movieImage.kf.setImage(with: "\(movie.posterPath ?? "")".url)
                movieTitleLbl.text = movie.title
            }
        }
    }
    
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLbl: UILabel!
}

extension String{
    var url: URL? {
        return URL(string: "\(posterUrl)\(self)")
    }
}

