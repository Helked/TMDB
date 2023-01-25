//
//  ResultState.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 24/1/23.
//

import Foundation


enum ResultState {
    case loading
    case success(content: [Movie])
    case failed(error: Error)
}
