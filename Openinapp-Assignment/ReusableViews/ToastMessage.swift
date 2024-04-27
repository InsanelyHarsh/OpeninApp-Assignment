//
//  ToastMessage.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 27/04/24.
//

import SwiftUI

struct ToastMessage: View {
	let message: String
	
	init(message: String) {
		self.message = message
	}
	
	var body: some View {
		Text("\(message)")
			.foregroundStyle(.white)
			.padding(.horizontal)
			.background {
				Capsule(style: .circular)
					.foregroundStyle(.gray.opacity(0.3))
			}
	}
}

struct ToastAlertModifier: ViewModifier {
	
	let message: String
	var isPresented: Binding<Bool>
	
	func body(content: Content) -> some View {
		content
			.overlay(alignment: .bottom) {
				ToastMessage(message: message)
					.opacity(isPresented.wrappedValue ? 1 : 0)
			}
	}
}

extension View {
	@ViewBuilder
	private func presentToast(isPresented: Binding<Bool>, _ message: String) -> some View {
		self
			.modifier(ToastAlertModifier(message: message, isPresented: isPresented))
	}
}
