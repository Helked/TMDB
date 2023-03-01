//
//  TVShowViewModel.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 1/3/23.
//

import Foundation
import Combine


class TVShowViewModel: ObservableObject {
    
    private var page: Int = 1
    private var totalPages: Int = 1
    
    private let service: MovieDBService
    
    private(set) var showsList = [Movie]()
    private(set) var genresList = [Genre]()
    
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var state: ResultState = .loading
    
    
    init(service: MovieDBService) {
        self.service = service
    }
    
   
    
    
    func getPopularTvShows() {
        if(self.page == 1){
            self.state = .loading
        }
        
        let cancellable = service
            .request(from: .getPopularTvShows(page: page), decodingType: ApiResponse.self)
            .sink { result in
                switch result{
                case .finished:
                    self.state = .success(content: self.showsList)
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { response in
                self.showsList.append(contentsOf: response.movies)
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
                    self.state = .success(content: self.showsList)
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { response in
                self.showsList.append(response)
            }
        self.cancellables.insert(cancellable)
    }
    
    
    private func searchTvShow(by title: String) {
        
        let cancellable = service
            .request(from: .searchTvShow(title: title, page: page), decodingType: ApiResponse.self)
            .sink { result in
                switch result{
                case .finished:
                    self.state = .success(content: self.showsList)
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { response in
                self.showsList.append(contentsOf: response.movies)
                self.totalPages = response.totalPages
            }
        self.cancellables.insert(cancellable)
    }
    
    
    func refreshPopularTvShows() {
        resetData()
        getPopularTvShows()
    }
    
    
    
    func search(by title: String) {
        resetData()
        self.state = .loading
        
        searchTvShow(by: title)
    }
    
    
    private func resetData() {
        self.page = 1
        self.totalPages = 1
        self.showsList.removeAll()
    }
    
    
    func loadMoreData(searchString: String?) {
        self.page += 1
        
        
        if(self.page <= self.totalPages){
            if(searchString == nil || searchString?.count == 0){
                getPopularTvShows()
            }else{
                searchTvShow(by: searchString!)
            }
            
        }
    }
    
    
    func getReleaseYear(show: Movie) -> String {
        
        if(show.release != nil){
            let dateComponents = show.release!.components(separatedBy: "-")
            return dateComponents[0]
        }
        
        if(show.firstDate != nil){
            let dateComponents = show.firstDate!.components(separatedBy: "-")
            return dateComponents[0]
        }
        
        return ""
        
    }
    
    
    func getTitle(show: Movie) -> String {
        if (show.title != nil) { return show.title! }
        if (show.name != nil) { return show.name! }
        return "No title"
    }
    
    
    
}
