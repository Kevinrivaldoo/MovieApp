//
//  ViewController.swift
//  MovieApp
//
//  Created by Kevin Rivaldo  on 18/03/22.
//

import UIKit
private let identifier = "MovieCell"

class TrendingMoviesView: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    //search view
    private var searching = false
    private var searchedMovie: [Movie] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var movies: [Movie] = []
    //endless scroll
    private var page: Int = 1
    private var totalPages: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let width = (view.frame.size.width - 20 ) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 190)
        
        self.title = "Trending Movies"
        
        fetch()
        configureSearchController()
    }
    
    private func configureSearchController()
    {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Movies"
    }
    
    
    private func fetch(_ page: Int = 1) {
        API.fetchPopularMovies(page) { data in
            self.totalPages = data.totalPages
            self.movies = data.results
            self.collectionView.reloadData()
        }
    }
    
    private func loadMoreData() {
        if page < totalPages {
            page += 1
            OperationQueue.main.addOperation {
                API.fetchPopularMovies(self.page) { data in
                    self.movies += data.results
                    self.collectionView.reloadData()
                }
            }
        }
    }
}


extension TrendingMoviesView: UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        if !searchText.isEmpty
        {
            searching = true
            searchedMovie.removeAll()
            for case let movie? in movies {
                if movie.title.lowercased().contains(searchText.lowercased())
                {
                    searchedMovie.append(movie)
                }
            }
        }
        else
        {
            searching = false
            searchedMovie.removeAll()
            searchedMovie = movies
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchedMovie.removeAll()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            return searchedMovie.count
        } else {
            return movies.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MovieCollectionViewCell
        if searching {
            cell.movie = searchedMovie[indexPath.item]
        } else {
            cell.movie = movies[indexPath.item]
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let count = movies.count else { fatalError() }
//
//        if indexPath.item == count - 1 {
//            self.loadMoreData()
//        }
//
//    }
}

