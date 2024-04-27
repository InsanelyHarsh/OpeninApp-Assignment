//
//  Constants.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 26/04/24.
//

import Foundation

struct Constants {
	///Wild access token for staging api in OIA - Access Token - Bearer
	static var token: String {
		get {
			"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjU5MjcsImlhdCI6MTY3NDU1MDQ1MH0.dCkW0ox8tbjJA2GgUx2UEwNlbTZ7Rr38PVFJevYcXFI"
		}
	}
	
	///Dashboard GET API 
	static var apiURL: String {
		get {
			"https://api.inopenapp.com/api/v1/dashboardNew"
		}
	}
}
