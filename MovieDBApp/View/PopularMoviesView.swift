//
//  PopularMoviesView.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 24/1/23.
//

import SwiftUI

struct PopularMoviesView: View {
    
    @ObservedObject var viewModel = MovieDBViewModel(service: MovieDBService())
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.state {
                case .loading:
                    VStack{
                        ProgressView()
                        Text("Loading")
                            .padding(10)
                    }
                case .failed(error: let error):
                    ErrorView(error: error,
                              errorButtonText: "Retry",
                              handler: viewModel.getPopularMovies)
                case .success(content: let movies):
                    List {
                        ForEach(movies) { movie in
                            NavigationLink(destination: MovieDetailView(movieId: movie.id)){
                                MovieCellView(movie: movie)
                            }
                        }
                        
                        ProgressView()
                            .onAppear{
                                viewModel.loadMoreData(isMovies: true)
                            }
                    }
                
                }
            }
            .navigationTitle("Popular movies")
            
        }
        .onAppear(perform: viewModel.getPopularMovies)
        .refreshable {
            viewModel.refreshPopularMovies()
        }
        
    }
    
}

struct PopularMoviesView_Previews: PreviewProvider {
    static var previews: some View {
        PopularMoviesView()
    }
}
