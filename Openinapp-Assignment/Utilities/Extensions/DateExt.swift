//
//  DateExt.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 27/04/24.
//

import Foundation

extension Date {
	var getLocalTimeGreeting: String {
		get{
			let hour = Calendar.current.component(.hour, from: self)
			
			switch hour {
			case 0..<12:
				return "Good morning"
			case 12..<18:
				return "Good Afternoon"
			default:
				return "Good Evening"
			}
		}
	}
}


func formatDate(dateString: String) -> String? {
	let dateFormatterInput = ISO8601DateFormatter()
	dateFormatterInput.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
	guard let date = dateFormatterInput.date(from: dateString) else {
		return nil
	}

	let dateFormatterOutput = DateFormatter()
	dateFormatterOutput.dateFormat = "dd MMM yyyy"
	dateFormatterOutput.locale = Locale(identifier: "en_US_POSIX") // Adjust locale as needed

	return dateFormatterOutput.string(from: date)
}
