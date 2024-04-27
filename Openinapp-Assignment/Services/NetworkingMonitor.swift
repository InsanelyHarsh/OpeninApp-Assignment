//
//  NetworkingMonitor.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 26/04/24.
//

import Foundation
import Network

enum NetworkingMonitorState {
	case loading
	case connected
	case noInternet
}

final class NetworkMonitor: ObservableObject {
	private let networkMonitor = NWPathMonitor()
	private let workerQueue = DispatchQueue(label: "Monitor")
	@Published var networkingMonitorState:NetworkingMonitorState = .loading

	init() {
		networkMonitor.pathUpdateHandler = { path in
			DispatchQueue.main.async {
				self.networkingMonitorState = (path.status == .satisfied) ? .connected : .noInternet
			}
		}
		networkMonitor.start(queue: workerQueue)
	}
}
