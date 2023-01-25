//
//  PopularMoviesView.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 24/1/23.
//

import SwiftUI

struct PopularMoviesView: View {
    
    @ObservedObject var viewModel = MovieDBViewModel(service: MovieDBService())
    @State var searchString: String = ""
    
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
                    VStack {
                        
                    
                    HStack(spacing: 10){
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        TextField("Search movie", text:$searchString)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 5)
                            .background(Color.white)
                        Button("search", action: {
                            if(searchString.count > 3){
                                viewModel.searchMovie(by: searchString)
                            }
                            if(searchString.count == 0){
                                viewModel.refreshPopularMovies()
                            }
                        })
                        .padding(.horizontal)
                            
                    }
                    
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
