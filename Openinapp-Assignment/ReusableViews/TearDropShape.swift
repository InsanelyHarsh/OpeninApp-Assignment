//
//  TearDropShape.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 27/04/24.
//

import SwiftUI

struct TearDrop: Shape {
	
	func path(in rect: CGRect) -> Path {
		Path { path in
			let height: CGFloat = 32
			let centerWidth = rect.width / 2
			
			path.move(to: .init(x: rect.minX, y: rect.minY)) // start top left
			path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: rect.minY)) // the beginning of the trough
			
			path.addCurve(to: CGPoint(x: centerWidth, y: rect.minY - height),
						  control1: CGPoint(x: (centerWidth - 30), y: rect.minY),
						  control2: CGPoint(x: centerWidth - 35, y: rect.minY - height))
			
			path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: rect.minY),
						  control1: CGPoint(x: centerWidth + 35, y: rect.minY - height),
						  control2: CGPoint(x: (centerWidth + 30), y: rect.minY))
			
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
			path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
			
			path.closeSubpath()
		}
	}
}
