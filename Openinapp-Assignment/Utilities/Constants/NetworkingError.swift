//
//  NetworkingError.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 26/04/24.
//

import Foundation

enum NetworkingError:Error {
	case invalidURL(urlString: String)
	case reqeustFailed(with: Error?)
	case invalidStatus(statusCode: Int)
	case emptyResponse
	case decodingFailed(error: Error)
	case encodingFailed(error: Error)
	
	case connectionFailed
	
	///Message Presented to User
	var userMessage: String {
		switch self {
		case .invalidURL:
			return "Internal Error"
		case .reqeustFailed( _), .decodingFailed(_), .encodingFailed(_):
			return "Something went wrong, Please try again later."
		case .invalidStatus, .emptyResponse:
			return "Unexpected Response, Please try again later"
		case .connectionFailed:
			return "Unable to connect to the server, Please try again later"
		}
	}
	
	var internalLogDescription: String {
		switch self {
		case .invalidURL(let urlString):
			return "[ERROR] Invalid URL: \(urlString)"
		case .reqeustFailed(let with):
			return "[ERROR] Request Failed with Error: \(with?.localizedDescription ?? "0")"
		case .invalidStatus(let statusCode):
			return "[ERROR] Invalid Response Status: \(statusCode)"
		case .emptyResponse:
			return "[ERROR] Empty Response from Server"
		case .decodingFailed(let error):
			return "[ERROR] Decoding Failed with Error: \(error.localizedDescription)"
		case .encodingFailed(let error):
			return "[ERROR] Encoding Failed with Error: \(error.localizedDescription)"
		case .connectionFailed:
			return "[ERROR] Connection Request Failed"
		}
	}
}
