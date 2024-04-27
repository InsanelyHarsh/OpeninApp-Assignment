//
//  NetworkingFetchState.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 27/04/24.
//

import Foundation

enum NetworkingFetchState {
	case loading
	case finished
	case failed(with: String)
}
