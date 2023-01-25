//
//  MovieDBViewModel.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 24/1/23.
//

import Foundation
import Combine


protocol MovieDBViewModelProtocol {
    func getPopularMovies()
}

class MovieDBViewModel: ObservableObject, MovieDBViewModelProtocol {
    
    var page: Int = 1
    
    private let service: MovieDBService
    
    private(set) var movieList = [Movie]()
    private(set) var genresList = [Genre]()
    
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var state: ResultState = .loading
    
    
    init(service: MovieDBService) {
        self.service = service
    }
    
   //MOVIES -----------------------------
    func getPopularMovies() {
        if(self.page == 1){
            self.state = .loading
        }
        
        let cancellable = service
            .request(from: .getPopularMovies(page: page), decodingType: ApiResponse.self)
            .sink { result in
                switch result{
                case .finished:
                    self.state = .success(content: self.movieList)
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { response in
                self.movieList.append(contentsOf: response.movies)
            }
        self.cancellables.insert(cancellable)
   
    }
    
    
    func getMovieDetails(movieId: Int) {
        
        self.state = .loading
        let cancellable = service
            .request(from: .getMovieDetails(id: movieId), decodingType: Movie.self)
            .sink { result in
                switch result{
                case .finished:
                    self.state = .success(content: self.movieList)
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { response in
                self.movieList.append(response)
            }
        self.cancellables.insert(cancellable)
    }
    
    func searchMovie(by title: String) {
        
        self.movieList.removeAll()
        self.state = .loading
        
        let cancellable = service
            .request(from: .searchMovie(title: title), decodingType: ApiResponse.self)
            .sink { result in
                switch result{
                case .finished:
                    self.state = .success(content: self.movieList)
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { response in
                self.movieList.append(contentsOf: response.movies)
            }
        self.cancellables.insert(cancellable)
    }
    
    func refreshPopularMovies() {
        self.page = 1
        self.movieList.removeAll()
        getPopularMovies()
    }
    
    //TVSHOWS -----------------------------
    
    func getPopularTvShows() {
        if(self.page == 1){
            self.state = .loading
        }
        
        let cancellable = service
            .request(from: .getPopularTvShows(page: page), decodingType: ApiResponse.self)
            .sink { result in
                switch result{
                case .finished:
                    self.state = .success(content: self.movieList)
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { response in
                self.movieList.append(contentsOf: response.movies)
            }
        self.cancellables.insert(cancellable)
   
    }
    
    
    func getTvShowDetails(movieId: Int) {
        
        self.state = .loading
        let cancellable = service
            .request(from: .getTvShowDetails(id: movieId), decodingType: Movie.self)
            .sink { result in
                switch result{
                case .finished:
                    self.state = .success(content: self.movieList)
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { response in
                self.movieList.append(response)
            }
        self.cancellables.insert(cancellable)
    }
    
    func refreshPopularTvShows() {
        self.page = 1
        self.movieList.removeAll()
        getPopularTvShows()
    }
    
    //------------------------
    
    
    func loadMoreData(isMovies: Bool) {
        self.page += 1
        isMovies ? getPopularMovies() : getPopularTvShows()
    }
    
    
    func getReleaseYear(movie: Movie) -> String {
        
        if(movie.release != nil){
            let dateComponents = movie.release!.components(separatedBy: "-")
            return dateComponents[0]
        }
        
        if(movie.firstDate != nil){
            let dateComponents = movie.firstDate!.components(separatedBy: "-")
            return dateComponents[0]
        }
        
        return ""
        
    }
    
    
    func getTitle(movie: Movie) -> String {
        if (movie.title != nil) { return movie.title! }
        if (movie.name != nil) { return movie.name! }
        return "No title"
    }
    
    
    
}


