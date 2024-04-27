//
//  AnalyticsSectionView.swift
//  Openinapp-Assignment
//
//  Created by Harsh Yadav on 27/04/24.
//

import SwiftUI

struct AnalyticsSectionView: View {
	var networkingState: NetworkingFetchState
	var topAnalyticsModel: TopAnalyticsModel
	let proxy: GeometryProxy
	
    var body: some View {
		VStack(spacing: 20) {
			
			AnalyticsChartView()
				.frame(height: proxy.size.height*0.4)
				.padding()
				.background {
					RoundedRectangle(cornerRadius: 10)
						.foregroundStyle(.white)
				}
				.padding(.horizontal)
			
			//MARK: Top Analytics
			ScrollView(.horizontal, showsIndicators: false) {
				HStack {
					switch networkingState {
					case .loading:
						topAnalyticsCellLoadingView
						
					case .failed(_):
						topAnalyticsCellLoadingView
						
					case .finished:
						topAnalyticsCell(.todayClicks, analyticValue: topAnalyticsModel.todayClicks)
						
						topAnalyticsCell(.topLocation, analyticValue: topAnalyticsModel.topLocation)
						
						topAnalyticsCell(.topSource, analyticValue: topAnalyticsModel.topSource)
					}
					
				}
				.offset(x: 15)
			}
			.ignoresSafeArea(.container, edges: .horizontal)
			
			//MARK: View Analytics Button
			Button(action: {
				
			}, label: {
				primaryButtonLabel(image: ImageAsset.viewAnalyticsButtonIcon, buttonTitle: "View Analytics")
			})
			.tint(.black)
		}
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
	private func topAnalyticsCell(_ analyticType: TopAnalyticsCell, analyticValue: String) -> some View {
		
		RoundedRectangle(cornerRadius: 10)
			.frame(width: proxy.size.width/3, height: proxy.size.width/3)
			.foregroundStyle(.white)
			.overlay(alignment: .center) {
				VStack(alignment: .leading,spacing: 15) {
					analyticType.cellImage
					
					Text(analyticValue)
						.bold()
					
					Text(analyticType.title)
						.foregroundStyle(.gray)
				}
			}
	}
	
	@ViewBuilder
	private var topAnalyticsCellLoadingView: some View {
		topAnalyticsCellLoadingCell
		topAnalyticsCellLoadingCell
		topAnalyticsCellLoadingCell
	}
	
	private var topAnalyticsCellLoadingCell: some View {
		RoundedRectangle(cornerRadius: 10)
			.frame(width: proxy.size.width/3, height: proxy.size.width/3)
			.foregroundStyle(.white)
			.overlay(alignment: .center) {
				VStack(alignment: .leading,spacing: 15) {
					Image(ImageAsset.topSourceIcon)
					
					Text("299")
						.bold()
						.background(Color.gray.cornerRadius(10))
					
					Text("Today's Clicks")
						.background(Color.gray.cornerRadius(10))
				}
				.shimer(.init(tint: .gray.opacity(0.3), highLight: .white, blur: 5))
			}
	}
}

#Preview {
   RootView()
}
