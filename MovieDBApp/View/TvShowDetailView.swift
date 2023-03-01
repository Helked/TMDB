//
//  TvShowDetailView.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 25/1/23.
//

import SwiftUI

struct TvShowDetailView: View {
    @ObservedObject var viewModel = TVShowViewModel(service: MovieDBService())
    let movieId: Int
    
    var body: some View {
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
                let tvShow: Movie = movies[0]
                
                VStack{
                    if let bannerUrl = tvShow.banner,
                       let url = URL(string: "\(URL_IMAGE_PATH)\(bannerUrl)"){
                        
                        MovieImageView(width: .infinity, height: 200, url: url)
                            
                    }else{
                        PlaceholderView()
                    }
                }
                
                
                Text(viewModel.getTitle(show: tvShow))
                    .font(.custom("Arial", size: 26))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 15)
                
                Text("(\(viewModel.getReleaseYear(show: tvShow)))")
                    .font(.custom("Arial", size: 26))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    
                
                HStack {
                    ForEach(tvShow.genres ?? []) { genre in
                        Text(genre.name)
                            .font(.custom("Arial", size: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 5)
                }
                
                if let tagline = tvShow.tagline {
                    Text(tagline)
                        .font(.custom("Arial", size: 18))
                        .padding(.top, 10)
                        .italic()
                }
                
                Text(tvShow.overview)
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
