//
//  FetchImageView.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 27/04/24.
//

import SwiftUI

struct FetchImageView<Content: View>: View {
	var urlString: String = ""
	@StateObject private var fetchImageViewModel: FetchImageViewModel = FetchImageViewModel()
	
	@ViewBuilder let placeholder: Content
	@ViewBuilder let imageData: (Data) -> Content
	
	init(url urlString: String, placeholder: @escaping ()->Content, imageData: @escaping ((Data) -> Content)) {
		self.urlString = urlString
		self.placeholder = placeholder()
		self.imageData = imageData
	}
	
	var body: some View {
		ZStack {
			switch fetchImageViewModel.imageLoadingStatus {
			case .loading:
				ProgressView()
			case .finished:
				imageData(fetchImageViewModel.imageData)
			case .failed:
				placeholder
					.onTapGesture {
						self.fetchImageViewModel.fetchImage(urlString)
					}
			}
		}
		.task {
			self.fetchImageViewModel.fetchImage(urlString)
		}
	}
}

#Preview {
	FetchImageView(url: "https://assets.nobroker.in/nb-new/public/List-Page/ogImage.png") {
		Image(systemName: "gear")
	} imageData: { data in
		Image(uiImage: UIImage(data: data)!)
	}

}

class FetchImageViewModel: ObservableObject {
	private let networkingService = NetworkingService()
	@Published var imageData: Data = Data()
	@Published var imageLoadingStatus: NetworkingFetchState = .loading
	
	
	func fetchImage(_ urlString: String) {
		
		if let imageData = CacheManager.shared.fetchCacheImage(identifier: urlString) {
			print("Fetching from Cache 📲 \(urlString) \n ")
			self.imageData = Data(referencing: imageData)
			self.imageLoadingStatus = .finished
			return
		}
		
		self.networkingService.getData(url: urlString) { result in
			switch result {
			case .success(let success):
				DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
					self.imageData = success
					CacheManager.shared.saveImageCache(NSData(data: success), identifier: urlString)
					self.imageLoadingStatus = .finished
					print("Fetched Image from Server 💻")
				}
			case .failure(let error):
				DispatchQueue.main.async {
					self.imageLoadingStatus = .failed(with: error.userMessage)
					print("fetchImage:: \(error.internalLogDescription) \n")
				}
			}
		}
	}
}
