//
//  AnalyticsChartView.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 27/04/24.
//

import SwiftUI
import Charts

struct AnalyticData: Hashable {
	let clicks: Int
	let month: String
}
struct AnalyticsChartView: View {
	let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.4), Color.accentColor.opacity(0)]),
										startPoint: .top,
										endPoint: .bottom)
	
	private let chartData: [AnalyticData] = [.init(clicks: 22, month: ""),
											 .init(clicks: 24, month: "Jan"),
											 .init(clicks: 30, month: "Feb"),
											 .init(clicks: 78, month: "Mar"),
											 .init(clicks: 75, month: "Apr"),
											 .init(clicks: 100, month: "May"),
											 .init(clicks: 50, month: "Jun"),
											 .init(clicks: 25, month: "Jul"),
											 .init(clicks: 100, month: "Aug"),
											 .init(clicks: 77, month: "-"),]
	var body: some View {
		
		VStack {
			HStack {
				Text("Overview")
					.frame(maxWidth: .infinity)
					.foregroundStyle(.gray)
				
				Spacer()
				
				HStack{
					Text("22 Aug - 23 Sept")
					Image(ImageAsset.timeIcon)
				}
				.padding(3)
				.background {
					RoundedRectangle(cornerRadius: 5)
						.stroke(lineWidth: 1)
						.foregroundStyle(.gray)
				}
				.frame(maxWidth: .infinity)
			}
			.font(.callout)
			.fontWeight(.light)
			.frame(maxWidth: .infinity)
			
			
			Chart {
				
				ForEach(chartData,id:\.self) { data in
					LineMark(x: .value("Month", data.month), y: .value("Clicks", data.clicks))
				}
				
				ForEach(chartData,id:\.self) { data in
					AreaMark(x: .value("Month", data.month), y: .value("Clicks", data.clicks))
				}.foregroundStyle(linearGradient)
			}
			.chartYAxis {
				AxisMarks(position: .leading, values: .stride(by: 25, roundLowerBound: true, roundUpperBound: true))
			}
			
		}
	}
}

#Preview {
    AnalyticsChartView()
}
