//
//  PopularTvShowsView.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 25/1/23.
//

import SwiftUI

struct PopularTvShowsView: View {
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
                              handler: viewModel.getPopularTvShows)
                case .success(content: let movies):
                    VStack{
                       
                        HStack(spacing: 10){
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            TextField("Search TV Show", text:$searchString)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 5)
                                .background(Color.white)
                            Button("search", action: {
                                if(searchString.count > 2){
                                    viewModel.search(by: searchString, isMovie: false)
                                }
                                if(searchString.count == 0){
                                    viewModel.refreshPopularTvShows()
                                }
                            })
                            .padding(.horizontal)
                            
                        }
                        
                        List {
                            ForEach(movies) { movie in
                                NavigationLink(destination: TvShowDetailView(movieId: movie.id)){
                                    MovieCellView(movie: movie)
                                }
                            }
                            
                            Color.white.frame(height: 2)
                                .onAppear{
                                    viewModel.loadMoreData(isMovies: false, searchString: nil)
                                }
                        }
                    }
                
                }
            }
            .navigationTitle("Popular TV Shows")
            
        }
        .onAppear(perform: viewModel.getPopularTvShows)
        .refreshable {
            searchString = ""
            viewModel.refreshPopularTvShows()
        }
        
    }
}

struct PopularTvShowsView_Previews: PreviewProvider {
    static var previews: some View {
        PopularTvShowsView()
    }
}
