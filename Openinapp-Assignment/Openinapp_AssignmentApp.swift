//
//  Openinapp_AssignmentApp.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 26/04/24.
//

import SwiftUI

/*
 1) Display greeting from the local time
 2) Create a chart from the given api response
 3) Add a Tab [Top links & Recent links] and create a list view to display the data you shall be
 */
@main
struct Openinapp_AssignmentApp: App {
	@StateObject private var networkMonitor = NetworkMonitor()
	
	var body: some Scene {
		WindowGroup {
			switch networkMonitor.networkingMonitorState {
			case .loading:
				ProgressView("Loading...")
			case .connected:
				RootView()
					.preferredColorScheme(.light)
			case .noInternet:
				ContentUnavailableView(
					"No Internet Connection",
					systemImage: "wifi.exclamationmark",
					description: Text("Please check your connection and try again.")
				).preferredColorScheme(.dark)
			}
		}
	}
}

