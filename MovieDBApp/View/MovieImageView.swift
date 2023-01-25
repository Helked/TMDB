//
//  MovieImageView.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 25/1/23.
//

import SwiftUI

struct MovieImageView: View {
    let width: CGFloat
    let height: CGFloat
    let url: URL
    
    var body: some View {
        AsyncImage(
                url: self.url,
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: self.width, height: self.height)
                             
                    },
                    placeholder: {
                        ProgressView()
                            .frame(width: self.width, height: self.height)
                    }
        )
    }
}

struct MovieImageView_Previews: PreviewProvider {
    static var previews: some View {
        MovieImageView(width: 100, height: 150, url:URL(string: "https://image.tmdb.org/t/p/w500/3p6n3VrDsh34ZmSQyVhnSmvvW1z.jpg")!)
    }
}
