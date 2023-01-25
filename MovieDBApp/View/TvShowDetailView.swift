//
//  TvShowDetailView.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 25/1/23.
//

import SwiftUI

struct TvShowDetailView: View {
    @ObservedObject var viewModel = MovieDBViewModel(service: MovieDBService())
    let movieId: Int
    
    private let urlImagePath = "https://image.tmdb.org/t/p/w500"
    
    var body: some View {
        Group {
            let _ = print(movieId)
            
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
                let movie: Movie = movies[0]
                
                VStack{
                    if let bannerUrl = movie.banner,
                       let url = URL(string: "\(self.urlImagePath)\(bannerUrl)"){
                        
                        MovieImageView(width: .infinity, height: 200, url: url)
                            
                    }else{
                        PlaceholderView()
                    }
                }
                
                
                Text(viewModel.getTitle(movie: movie))
                    .font(.custom("Arial", size: 26))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 15)
                
                Text("(\(viewModel.getReleaseYear(movie: movie)))")
                    .font(.custom("Arial", size: 26))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    
                
                HStack {
                    ForEach(movie.genres ?? []) { genre in
                        Text(genre.name)
                            .font(.custom("Arial", size: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 5)
                }
                
                if let tagline = movie.tagline {
                    Text(tagline)
                        .font(.custom("Arial", size: 18))
                        .padding(.top, 10)
                        .italic()
                }
                
                Text(movie.overview)
                    .font(.custom("Arial", size: 18))
                    .padding(10)
                
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.getTvShowDetails(movieId: movieId)
        }
    }
}

struct TvShowDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TvShowDetailView(movieId: 100088)
    }
}
