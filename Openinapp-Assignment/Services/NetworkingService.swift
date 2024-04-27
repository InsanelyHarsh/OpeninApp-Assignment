//
//  NetworkingService.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 26/04/24.
//

import Foundation

final class NetworkingService {
	public func getRequest<T:Decodable>(url urlString: String,
										token: String = "",
										handler: @escaping (Result<T,NetworkingError>) -> Void) {
		

		guard let url = URL(string: urlString) else {
			handler(.failure(.invalidURL(urlString: urlString)))
			return
		}

		var request = URLRequest(url: url)
		if !token.isEmpty {
			request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			
			guard error == nil else {
				handler(.failure(.reqeustFailed(with: error)))
				return
			}
			
			guard let response = response, let statusCode = response as? HTTPURLResponse else {
				return
			}
			
			if statusCode.statusCode < 200 ||  statusCode.statusCode > 299 {
				handler(.failure(.invalidStatus(statusCode: statusCode.statusCode)))
				return
			}
			
			guard let data = data else { return }
			
			do {
				let decodedData = try JSONDecoder().decode(T.self, from: data)
				handler(.success(decodedData))
			}catch(let error) {
				handler(.failure(.decodingFailed(error: error)))
				return
			}
			
		}.resume()
	}
	
	public func getData(url urlString:String,
						handler: @escaping (Result<Data,NetworkingError>) -> Void) {
		guard let url = URL(string: urlString) else {
			handler(.failure(.invalidURL(urlString: urlString)))
			return
		}
		
		let request = URLRequest(url: url)
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			
			guard error == nil else {
				handler(.failure(.reqeustFailed(with: error)))
				return
			}
			
//            guard let response = response, let statusCode = response as? HTTPURLResponse else {
//                return
//            }
			
//            if statusCode.statusCode < 200 ||  statusCode.statusCode > 299 {
//                handler(.failure(.invalidStatus))
//                return
//            }
			
			guard let data = data else {
				handler(.failure(.emptyResponse))
				return
			}
			
			handler(.success(data))
			
		}.resume()
	}
	
	private func isValidURL(_ urlString: String) throws -> URL {
		guard let url = URL(string: urlString) else {
			throw NetworkingError.invalidURL(urlString: urlString)
		}
		
		return url
	}
}
