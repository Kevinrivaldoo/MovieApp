//
//  API+Manager.swift
//  MovieApp
//
//  Created by Kevin Rivaldo  on 18/03/22.
//

import Foundation
import Alamofire

private let baseUrl = "https://api.themoviedb.org/3/movie/"
let posterUrl = "https://image.tmdb.org/t/p/original"
private let coder = JSONDecoder()

class API {
    class func fetchPopularMovies(_ page: Int, onSuccess: @escaping (Result) -> Void ) {
        coder.keyDecodingStrategy = .convertFromSnakeCase
        let urlStr = "\(baseUrl)popular?api_key=88a8b9b29d2fd7cd6c976f0b79c01ca3&page=\(page)"
        guard let url = URL(string: urlStr) else { fatalError("Unable to get url")}
        
        AF.request(url).response {  response in
            switch response.result {
            case .success(let data):
                guard let data = data else { fatalError("No data returned!")}
                guard let results = try? coder.decode(Result.self, from: data) else { fatalError("Unable to parse data in to json")}
                DispatchQueue.main.async {
                    onSuccess(results)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
