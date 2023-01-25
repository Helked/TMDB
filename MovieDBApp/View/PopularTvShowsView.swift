//
//  PopularTvShowsView.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 25/1/23.
//

import SwiftUI

struct PopularTvShowsView: View {
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
                              handler: viewModel.getPopularTvShows)
                case .success(content: let movies):
                    List {
                        ForEach(movies) { movie in
                            NavigationLink(destination: TvShowDetailView(movieId: movie.id)){
                                MovieCellView(movie: movie)
                            }
                        }
                        
                        ProgressView()
                            .onAppear{
                                viewModel.loadMoreData(isMovies: false)
                            }
                    }
                
                }
            }
            .navigationTitle("Popular TV Shows")
            
        }
        .onAppear(perform: viewModel.getPopularTvShows)
        .refreshable {
            viewModel.refreshPopularTvShows()
        }
        
    }
}

struct PopularTvShowsView_Previews: PreviewProvider {
    static var previews: some View {
        PopularTvShowsView()
    }
}
