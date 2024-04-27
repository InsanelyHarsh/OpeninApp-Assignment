//
//  TopAnalyticsCell.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 27/04/24.
//

import SwiftUI

enum TopAnalyticsCell: String {
	case todayClicks
	case topSource
	case topLocation
	
	var title: String {
		switch self {
		case .todayClicks:
			return "Today's Clicks"
		case .topSource:
			return "Top Source"
		case .topLocation:
			return "Top Location"
		}
	}
	
	var cellImage: Image {
		switch self {
		case .todayClicks:
			Image(ImageAsset.todayClickIcon)
		case .topSource:
			Image(ImageAsset.topSourceIcon)
		case .topLocation:
			Image(ImageAsset.topLocationIcon)
		}
	}
}
