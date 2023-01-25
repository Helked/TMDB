//
//  HomeView.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 25/1/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
                PopularMoviesView()
                .tabItem {
                    Image(systemName: "popcorn.fill")
                    Text("Popular movies")
                }
                
                PopularTvShowsView()
                .tabItem{
                    Image(systemName: "tv.fill")
                    Text("Popular TV Shows")
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
