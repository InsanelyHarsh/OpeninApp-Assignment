//
//  HomeView.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 26/04/24.
//

import SwiftUI

struct HomeView: View {
	
	@EnvironmentObject var homeViewModel: HomeViewModel
	
    var body: some View {
		ZStack(alignment: .top) {
			
			Color.blue
				.ignoresSafeArea()
			
			HStack {
				Text("Dashboard")
					.bold()
					.font(.title2)
				Spacer()
				
				Image(ImageAsset.settingsIcon)
			}
			.padding(.horizontal)
			.foregroundStyle(.white)
			
			
			GeometryReader { geoProxy in
				ZStack {
					Color.backgroundGrayColor
						.ignoresSafeArea()
					
					ScrollView(showsIndicators: false) {
						ScrollViewReader{ proxy in
							VStack(spacing: 20){

								greetingsHeader
								
								//Chart, Top Stats and `View Analytics`
								AnalyticsSectionView(networkingState: homeViewModel.networkingFetchState,
													 topAnalyticsModel: homeViewModel.dashboardModel.topAnalyticsModel,
													 proxy: geoProxy)
								
								//Link Selection & Search Header, Link List and `View all Links`
								LinksSectionView(homeViewModel: homeViewModel, geoProxy: geoProxy, scrollProxy: proxy)
								
								Button(action: {
									self.openWhatsapp(with: homeViewModel.dashboardModel.supportWhatsappNumber)
								}, label: {
									reachOutButtonLabel(image: ImageAsset.whatsappIcon, buttonTitle: "Talk with us", color: .green)
								})
								.tint(.black)
								
								Button(action: {}, label: {
									reachOutButtonLabel(image: ImageAsset.faqIcon, buttonTitle: "Frequently Asked Questions", color: .blue)
								})
								.tint(.black)
								
							}
							.offset(y: 15)
							.id("ScrollableContent")
							.padding(.bottom, geoProxy.size.height*0.25)
						}
					}
					.refreshable {
						self.homeViewModel.fetchData()
					}
				}
				.cornerRadius(30)
				.offset(y: 60)
			}
		}
		.onAppear {
			homeViewModel.fetchData()
		}
    }
	
	private var greetingsHeader: some View {
		HStack {
			VStack(alignment: .leading, spacing: 10) {
				Text(Date.now.getLocalTimeGreeting)
					.font(.subheadline)
					.foregroundStyle(.gray)
				
				HStack(spacing: 4){
					Text("Ajay Manva")
					
					Text("👋")
						.scaleEffect(x: -1, y: 1)
				}
				.font(.title2)
				.fontWeight(.semibold)
			}
			
			Spacer()
		}
		.padding(.horizontal)
	}
	
	@ViewBuilder
	private func reachOutButtonLabel(image imageString: String, buttonTitle: String, color: Color = .green) -> some View {
		HStack {
			Image(imageString)
			
			Text(buttonTitle)
			
			Spacer()
		}
		.padding(.leading)
		.bold()
		.frame(maxWidth: .infinity)
		.padding()
		.background {
			RoundedRectangle(cornerRadius: 5)
				.foregroundStyle(color.opacity(0.2))
				.overlay {
					RoundedRectangle(cornerRadius: 5)
						.stroke(color, lineWidth: 1.0)
				}
				.padding(.horizontal)
		}
	}
	
	func openWhatsapp(with phoneNumber: String){
		let urlWhats = "whatsapp://send?phone=\(phoneNumber)"
		if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
			if let whatsappURL = URL(string: urlString) {
				if UIApplication.shared.canOpenURL(whatsappURL){
					UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
				}
				else {
					print("Install Whatsapp")
				}
			}
		}
	}
}

#Preview {
    RootView()
}
