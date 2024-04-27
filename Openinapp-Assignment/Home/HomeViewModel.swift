//
//  HomeViewModel.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 26/04/24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
	private let networkingService: NetworkingService = NetworkingService()
	
	@Published private var model: Model = Model(status: false, statusCode: 0, message: "")
	
	@Published private(set) var dashboardModel: DashboardModel = DashboardModel()
	@Published private(set) var networkingFetchState: NetworkingFetchState = .loading
	
	@Published var selectedLinkListType: LinkListType = .topLinks {
		didSet { updateLinkList() }
	}
	@Published var searchQuery: String = "" {
		didSet { performSearch(with: searchQuery) }
	}
	 @Published var isSearching: Bool = false {
		didSet { isSearching ? performSearch() : stopSearch() }
	}
	
	func fetchData() {
		networkingService.getRequest(url: Constants.apiURL, token: Constants.token) { [weak self] (result:Result<Model,NetworkingError>) in
			
			guard let self = self else { return }
			
			switch result {
			case .failure(let failure):
				//TODO: show alert
				self.networkingFetchState = .failed(with: failure.userMessage)
				print(failure.internalLogDescription)
			case .success(let success):
				DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
					self.model = success
					updateDashboardModel()
					withAnimation {
						self.networkingFetchState = .finished
					}
				}
			}
		}
	}
	
	private func updateDashboardModel() {
		self.dashboardModel.topAnalyticsModel =  TopAnalyticsModel(todayClicks: "\(model.todayClicks ?? 0)", topLocation: model.topLocation ?? "", topSource: model.topSource ?? "")
		self.dashboardModel.supportWhatsappNumber = model.supportWhatsappNumber ?? ""
		updateLinkList()
	}
	
	private func updateLinkList() {
		
		guard let data = model.data else { return }
		
		switch selectedLinkListType {
		case .topLinks:
			self.dashboardModel.links = data.topLinks
		case .recentLinks:
			self.dashboardModel.links = data.recentLinks
		}
	}
	
	private func performSearch(with searchQuery: String = "") {
		guard let data = model.data else { return }
		
		switch selectedLinkListType {
		case .topLinks:
			dashboardModel.links = data.topLinks.filter {
				if !searchQuery.isEmpty {
					$0.title.lowercased().contains(searchQuery.lowercased())
				}else { true }
			}
		case .recentLinks:
			dashboardModel.links = data.recentLinks.filter {
				if !searchQuery.isEmpty {
					$0.title.lowercased().contains(searchQuery.lowercased())
				}else { true }
			}
		}
	}
	
	private func stopSearch() {
		self.searchQuery = ""
		updateLinkList()
	}
}


