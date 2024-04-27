//
//  LinksSectionView.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 27/04/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct LinksSectionView: View {
	
	@ObservedObject var homeViewModel: HomeViewModel
	@Namespace private var selectedLinkTypeAnimation
	@FocusState private var searchFieldFocused: Bool
	
	let geoProxy: GeometryProxy
	let scrollProxy: ScrollViewProxy
	var body: some View {
		
		VStack(alignment: .center, spacing: 20) {
			
			//Links Header
			linkSectionHeader
			
			//Link Lists
			switch homeViewModel.networkingFetchState {
			case .loading:
				linkDetailLoadingView
			case .failed(_):
				linkDetailLoadingView
			case .finished:
				ForEach(homeViewModel.dashboardModel.links, id:\.urlID) { link in
					linkDetailCell(link)
				}
			}
			
			//MARK: view all Link Button
			Button(action: {
				
			}, label: {
				primaryButtonLabel(image: ImageAsset.viewAllLinksButtonIcon, buttonTitle: "View all Links")
			})
			.tint(.black)

		}
	}
	
	private var linkSectionHeader: some View {
		HStack{
			
			if homeViewModel.isSearching {
				TextField("Search Link", text: $homeViewModel.searchQuery)
					.padding(.leading)
					.padding(10)
					.focused($searchFieldFocused)
				
				Image(systemName: "multiply.circle.fill")
					.foregroundStyle(.red)
					.onTapGesture {
						self.homeViewModel.isSearching = false
						self.searchFieldFocused = false
						withAnimation {
							scrollProxy.scrollTo("ScrollableContent", anchor: .top)
						}
					}
					.padding(10)
				
			}else {
				ScrollView(.horizontal, showsIndicators: false) {
					
					HStack(spacing: 20){
						ForEach(LinkListType.allCases, id:\.rawValue) { linkType in
							Text(linkType.rawValue)
								.foregroundStyle(homeViewModel.selectedLinkListType == linkType ? .white : .gray)
								.padding(10)
								.background {
									ZStack {
										RoundedRectangle(cornerRadius: 20)
											.foregroundStyle(.clear)
										
										if homeViewModel.selectedLinkListType == linkType {
											Capsule(style: .circular)
												.foregroundStyle(.blue)
												.matchedGeometryEffect(id: "selectedLinkTypeAnimation", in: selectedLinkTypeAnimation)
										}
									}
								}
								.onTapGesture {
									withAnimation {
										self.homeViewModel.selectedLinkListType = linkType
									}
								}
							
						}
					}
					.offset(x: 15)
				}
				
				Image(ImageAsset.searchButtonIcon)
					.onTapGesture {
						
						//if homeViewModel.networkingFetchState == .loading { return }
						
						self.homeViewModel.isSearching = true
						self.searchFieldFocused = true
						withAnimation {
							scrollProxy.scrollTo("SEARCH_TEXT_FIELD", anchor: .top)
						}
					}
			}
		}
		.id("SEARCH_TEXT_FIELD")
		.padding(.trailing)
		.ignoresSafeArea(.container, edges: .horizontal)

	}
	
	@ViewBuilder
	private func primaryButtonLabel(image imageString: String, buttonTitle: String) -> some View {
		HStack {
			Image(imageString)
			
			Text(buttonTitle)
		}
		.bold()
		.frame(maxWidth: .infinity)
		.padding(.horizontal)
		.padding(.vertical, 8)
		.background {
			RoundedRectangle(cornerRadius: 5)
				.stroke(.gray, lineWidth: 1.0)
				.opacity(0.3)
				.padding(.horizontal)
		}
		
	}
	
	@ViewBuilder
	private var linkDetailLoadingView: some View {
		linkDetailLoadingCell
		linkDetailLoadingCell
		linkDetailLoadingCell
		linkDetailLoadingCell
	}
	
	
	@ViewBuilder
	private func linkDetailCell(_ link:DashboardLink) -> some View {
		VStack(spacing: 0) {
			HStack {
				FetchImageView(url: link.originalImage, placeholder: {
					Image(systemName: "gear")
						.resizable()
				}, imageData: { data in
					if let uiImage = UIImage(data: data) {
						Image(uiImage: uiImage)
							.resizable()
					}else {
						Image(systemName: "gear")
							.resizable()
					}
				})
				.frame(width: geoProxy.size.width*0.133, height: geoProxy.size.width*0.133, alignment: .center)
				.clipShape(RoundedRectangle(cornerRadius: 10))
				
				VStack(alignment: .leading) {
					HStack {
						Text(link.title)
							.lineLimit(1)
						
						Spacer()
						
						Text("\(link.totalClicks)")
					}
					
					HStack {
						if let createdAt = formatDate(dateString: link.createdAt) {
							Text(createdAt)
								.foregroundStyle(.gray)
						}
						
						Spacer()
						
						Text("Clicks")
					}
					.font(.caption2)
					.foregroundStyle(.gray)
				}
			}
			.padding()
			.background {
				UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12, style: .circular)
					.foregroundStyle(.white)
			}
			
			
			HStack {
				Link(link.webLink, destination: URL(string: link.webLink)!)
					.lineLimit(1)
					.foregroundStyle(.blue)
					.tint(.blue)
					.frame(width: geoProxy.size.width*0.5)

				
				Spacer()
				
				Button(action: {
					UIPasteboard.general.setValue(link.webLink,
								forPasteboardType: UTType.plainText.identifier)

				}, label: {
					Image(ImageAsset.copyButtonIcon)
				})
			}
			.padding()
			.background {
				ZStack {
					UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 12, bottomTrailingRadius: 12, topTrailingRadius: 0, style: .circular)
						.foregroundStyle(.blue.opacity(0.1))
					
					UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 12, bottomTrailingRadius: 12, topTrailingRadius: 0, style: .circular)
						.stroke(style: StrokeStyle(lineWidth: 2, dash: [2.5]))
						.foregroundStyle(.blue.opacity(0.2))
				}
			}
			.tint(.blue)
		}
		.padding()
	}
	
	var linkDetailLoadingCell: some View {
		VStack(spacing: 0) {
			HStack {
				RoundedRectangle(cornerRadius: 10)
					.frame(width: 50, height: 50, alignment: .center)
					.background(.gray)
				
				VStack(alignment: .leading) {
					HStack {
						Text("link.title")
							.lineLimit(1)
							.background(.gray)
						
						Spacer()
					}
					
					HStack {
							Text("createdAt")
								.background(.gray)
						
						Spacer()
					}
				}
			}
			.padding()
			.background {
				UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12, style: .circular)
					.foregroundStyle(.white)
			}
			
			
			HStack {
				Text("https://google.com/")
					.lineLimit(1)
					.foregroundStyle(.blue)
					.tint(.blue)
					.background(.gray)
				
				Spacer()
			}
			.padding()
			.background {
				ZStack {
					UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 12, bottomTrailingRadius: 12, topTrailingRadius: 0, style: .circular)
						.foregroundStyle(.blue.opacity(0.1))
					
					UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 12, bottomTrailingRadius: 12, topTrailingRadius: 0, style: .circular)
						.stroke(style: StrokeStyle(lineWidth: 2, dash: [2.5]))
						.foregroundStyle(.blue.opacity(0.2))
				}
			}
			.tint(.blue)
		}
		.padding()
		.shimer(.init(tint: .gray.opacity(0.3), highLight: .white, blur: 5))
	}
}

#Preview {
    HomeView()
}
