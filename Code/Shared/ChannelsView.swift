import Foundation
import SwiftUI


/// View for a channels
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
struct ChannelsView: View {
	// MARK: Properties
	
	/// The channels
	@EnvironmentObject var channels: Channels
	
	
	
	/// The actual view
	var body: some View {
		NavigationView {
			GeometryReader(content: { geometry in
				List {
					ForEach(channels.all) { channel in
						NavigationLink(destination:
							ChannelView(channel: channel)
							.environmentObject(channels)
							.navigationBarHidden(true)
							.navigationBarBackButtonHidden(true)
						) {
							ChannelCellView(channel: channel)
						}
					}
					.onMove { fromOffsets, toOffset in
						channels.all.move(fromOffsets: fromOffsets, toOffset: toOffset)
					}
				}
				.listStyle(PlainListStyle())
				.navigationBarHidden(true)
				.overlay(VStack{
					Color.primary
					.colorScheme(.light)
					.frame(width: geometry.size.width, height: max(0, geometry.safeAreaInsets.top-1), alignment: .topLeading)
					.edgesIgnoringSafeArea(.top)
					
					Spacer()
				})
			})
			
			if let channel = channels.all.first {
				ChannelView(channel: channel)
				.environmentObject(channels)
				.navigationBarHidden(true)
				.navigationBarBackButtonHidden(true)
			}
		}
		.colorScheme(.dark)
	}
}

