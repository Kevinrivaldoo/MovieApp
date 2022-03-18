//
//  Result.swift
//  MovieApp
//
//  Created by Kevin Rivaldo  on 18/03/22.
//

import Foundation

struct Result: Codable {
    let results: [Movie]
    let page: Int
    let totalPages: Int
    let totalResults: Int
    
}
