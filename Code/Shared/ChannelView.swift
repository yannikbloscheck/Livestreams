import Foundation
import SwiftUI


/// View for a channel
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
struct ChannelView: View {
	// MARK: Properties
	
	/// The current presentation mode
	@Environment(\.presentationMode) var presentationMode
	
	
	
	/// The current presentation mode
	@Environment(\.horizontalSizeClass) var horizontalSizeClass
	
	
	
	/// The channels
	@EnvironmentObject var channels: Channels
	
	
	
	/// The channel
	let channel: Channel
	
	
	
	/// If the livestream chooser is being presented
	@State var isPresentingLivestreamChooser: Bool = false
	
	
	
	/// The buttons of the livestream chooser
	var livestreamChooserButtons: [ActionSheet.Button] {
		get {
			var buttons: [ActionSheet.Button] = []
			
			if channel.livestreams.count > 1 {
				for livestream in channel.livestreams {
					let button = ActionSheet.Button.default(Text((livestream == channel.preferredLivestream ? "✓ " : "") + (livestream.title ?? "Unknown"))) {
						channels.preferLivestream(livestream, for: channel)
						channels.livestream = livestream
						channels.objectWillChange.send()
					}
					buttons.append(button)
				}
			}
			
			let button = ActionSheet.Button.cancel()
			buttons.append(button)
			
			return buttons
		}
	}
	
	
	
	/// The actual view
	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				channel.primaryColor
				
				channel.secondaryColor
			}
			.frame(idealWidth: .infinity, maxWidth: .infinity, maxHeight: .infinity)
			.edgesIgnoringSafeArea([.top, .bottom])
			
			VStack(spacing: 0) {
				HStack {
					Spacer()
					
					channel.logo
					
					Spacer()
				}
				.frame(idealWidth: .infinity, maxWidth: .infinity, minHeight: 100, idealHeight: 100, maxHeight: 100)
				.background(channel.primaryColor)
				.overlay(
					HStack {
						Button {
							presentationMode.wrappedValue.dismiss()
							
							showSidebar()
						} label: {
							VStack {
								Spacer()
								
								if UIDevice.current.orientation.isPortrait || UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isPortrait ?? false {
									Image(systemName: "chevron.backward")
								}
								
								Spacer()
							}
							.padding([.leading, .trailing], 20)
						}
						
						Spacer()
					}
				)
				
				LivestreamView()
				.environmentObject(channels)
				.aspectRatio(contentMode: .fill)
				
				HStack {
					Text(channel.currentShow?.time ?? "")
					.font(.title3)
					.bold()
					.lineLimit(1)
					
					Text(channel.currentShow?.title ?? "")
					.font(.title3)
					.lineLimit(1)
					
					Spacer()
					
					if channel.livestreams.count > 1 {
						Button {
							isPresentingLivestreamChooser = true
						} label: {
							Image(systemName: "rectangle.stack.fill")
						}
						.actionSheet(isPresented: $isPresentingLivestreamChooser) {
							ActionSheet(title: Text("Choose Version"), message: nil, buttons: livestreamChooserButtons)
								
						}
						
					}
				}
				.foregroundColor(.accentColor)
				.padding([.top, .bottom], 10)
				.padding([.leading, .trailing], 16)
				.background(channel.primaryColor)
				
				ScrollView(.vertical, showsIndicators: false) {
					LazyVStack(alignment: .leading, spacing: 10) {
						ForEach(channel.nextShows) { show in
							HStack {
								Text(show.time)
								.font(.footnote)
								.bold()
								.lineLimit(1)
								
								Text(show.title)
								.font(.footnote)
								.lineLimit(1)
							}
						}
					}
					.foregroundColor(.accentColor)
					.padding([.top, .bottom], 20)
					.padding([.leading, .trailing], 32)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				
				Spacer()
			}
			.background(channel.secondaryColor)
			.edgesIgnoringSafeArea([.bottom])
		}
		.onAppear() {
			channels.current = channel
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

