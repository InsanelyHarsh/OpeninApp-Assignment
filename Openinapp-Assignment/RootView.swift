//
//  RootView.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 27/04/24.
//

import SwiftUI


struct TabItem: Equatable, Hashable {
	let title: String
	let icon: String
}

enum TabBarItemType:CaseIterable {
	case links
	case courses
	case plusIcon
	case campaigns
	case profile
	
	var tabItem: TabItem {
		switch self {
		case .links:
			return .init(title: "Links", icon: ImageAsset.linksTabIcon)
		case .courses:
			return .init(title: "Courses", icon: ImageAsset.coursesTabIcon)
		case .plusIcon:
			return .init(title: "", icon: ImageAsset.plusTabIcon)
		case .campaigns:
			return .init(title: "Campaigns", icon: ImageAsset.campaignsTabIcon)
		case .profile:
			return .init(title: "Profile", icon: ImageAsset.profileTabIcon)
		}
	}
}

struct RootView: View {
	
	@StateObject private var homeViewModel: HomeViewModel = HomeViewModel()
	
	@State private var selectedTabItem: TabBarItemType = TabBarItemType.links
	
    var body: some View {
		ZStack(alignment: .center){
			
			ZStack{
				switch selectedTabItem {
				case .links:
					HomeView()
						.environmentObject(homeViewModel)
				case .courses:
					Text("Courses")
				case .plusIcon:
					Text("Add")
				case .campaigns:
					Text("Campaigns")
				case .profile:
					Text("Profile")
				}
			}
			
			
			VStack {
				Spacer()
					HStack {
						ForEach(TabBarItemType.allCases,id:\.self) { tab in
							tabBarItem(tab)
								.onTapGesture {
									self.selectedTabItem = tab
								}
						}
					}
					.background {
						TearDrop()
							.ignoresSafeArea(.all, edges: .bottom)
							.foregroundStyle(.white)
					}
			}
		}
    }
	
	@ViewBuilder
	private func tabBarItem(_ tab:TabBarItemType) -> some View {
		VStack {
			Image(tab.tabItem.icon)
				.scaleEffect(tab == .plusIcon ? 1.2 : 1)
				.offset(y:tab == .plusIcon ? -25 : 0)
			
			Text(tab.tabItem.title)
				.font(.caption)
		}
		.foregroundStyle(.black)
		.opacity(selectedTabItem == tab ? 1 : 0.4)
		.frame(maxWidth: .infinity)
		.onTapGesture {
			self.selectedTabItem = tab
		}
	}
}

#Preview {
	RootView()
}
