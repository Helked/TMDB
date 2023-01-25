//
//  MovieCellView.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 24/1/23.
//

import SwiftUI

struct MovieCellView: View {
    
    let movie: Movie
    
    
    private let urlImagePath = "https://image.tmdb.org/t/p/w500"
    var viewModel = MovieDBViewModel(service: MovieDBService())
    
    
    
    
    var body: some View {
        HStack (alignment: .top) {
            if let imgUrl = movie.poster,
               let url = URL(string: "\(self.urlImagePath)\(imgUrl)"){
                
                MovieImageView(width: 100, height: 150, url: url)
                
            }else{
                PlaceholderView()
            }
            VStack {
                
                Text(viewModel.getTitle(movie: movie))
                    .font(.headline)
                    .fontWeight(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Text("(\(viewModel.getReleaseYear(movie: movie)))")
                    .font(.custom("Arial", size: 14))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                Text(movie.overview)
                    .font(.custom( "Arial", size: 12))
                    .padding(1)
                
                HStack {
                    Text("Rating:")
                    Text(String(format: "%.2f", movie.score))
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
                .font(.custom("Arial", size: 11))
                .padding(1)
                    
            }
        }
    }
}

struct MovieCellView_Previews: PreviewProvider {
    static var previews: some View {
        MovieCellView(movie: .dummyData)
            .previewLayout(.sizeThatFits)
    }
}
