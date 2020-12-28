import Foundation
import SwiftUI


/// View for a channels
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
struct ChannelsView: View {
	// MARK: Properties
	
	/// The channels
	@EnvironmentObject var channels: Channels
	
	
	
	/// A timer to refresh the program every half minute
	private var timer = Timer.publish(every: 30, on: .main, in: .default).autoconnect()
	
	
	
	/// The actual view
	var body: some View {
		NavigationView {
			GeometryReader(content: { geometry in
				ZStack {
					List {
						ForEach(channels.all) { channel in
							NavigationLink(destination:
								ChannelView(channel: channel)
								.environmentObject(channels)
								.navigationBarHidden(true)
								.navigationBarBackButtonHidden(true)
							, tag:
								channel
							, selection:
								$channels.selected
							,label: {
								ChannelCellView(channel: channel)
								.environmentObject(channels)
							})
						}
						.onMove { fromOffsets, toOffset in
							channels.all.move(fromOffsets: fromOffsets, toOffset: toOffset)
						}
					}
					.listStyle(PlainListStyle())
					.navigationBarHidden(true)
					
					VStack {
						Color(UIColor.systemGroupedBackground)
						.frame(width: geometry.size.width, height: max(0, geometry.safeAreaInsets.top-1), alignment: .topLeading)
						.edgesIgnoringSafeArea(.top)
						
						Spacer()
					}
				}
			})
			
			if let channel = channels.all.first {
				ChannelView(channel: channel)
				.environmentObject(channels)
				.navigationBarHidden(true)
				.navigationBarBackButtonHidden(true)
				.onAppear {
					showSidebar()
				}
			}
		}
		.colorScheme(.dark)
		.onReceive(timer) { (timer) in
			channels.objectWillChange.send()
		}
	}
	
	
	
	
	// MARK: Methods
	
	/// Show the sidebar
	func showSidebar() {
		for window in UIApplication.shared.windows {
			for viewController in window.rootViewController?.children ?? [] {
				if let splitViewController = viewController as? UISplitViewController {
					splitViewController.show(.primary)
				}
			}
		}
	}
}

