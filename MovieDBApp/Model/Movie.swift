//
//  Movie.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 24/1/23.
//

import Foundation

struct ApiResponse: Decodable {
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct Movie: Decodable, Identifiable {
    let id: Int
    let title: String?
    let name: String?
    let poster: String
    let banner: String?
    let release: String?
    let firstDate: String?
    let overview: String
    let score: Double
    let genres: [Genre]?
    let tagline: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case poster = "poster_path"
        case banner = "backdrop_path"
        case release = "release_date"
        case firstDate = "first_air_date"
        case overview
        case score = "vote_average"
        case genres
        case tagline
    }
    
}

struct Genre: Decodable, Identifiable {
    let id: Int
    let name: String
}


extension Movie {
    static var dummyData: Movie {
        .init(id: 603,
              title: "The Matrix",
              name: nil,
              poster: "/3p6n3VrDsh34ZmSQyVhnSmvvW1z.jpg",
              banner: "/waCRuAW5ocONRehP556vPexVXA9.jpg",
              release: "1999-03-30",
              firstDate: nil,
              overview: "Thomas Anderson lleva una doble vida: por el día es programador en una importante empresa de software, y por la noche un hacker informático llamado Neo. Su vida no volverá a ser igual cuando unos misteriosos personajes le inviten a descubrir la respuesta a la pregunta que no le deja dormir: ¿qué es Matrix?",
              score: 8.195,
              genres: [ Genre(id: 28, name: "Acción"),
                      Genre(id: 878, name: "Ciencia ficción")],
              tagline: "Bienvenido al mundo real"
            )
    }
    
    
}
