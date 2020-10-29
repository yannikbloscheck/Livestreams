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
					let button = ActionSheet.Button.default(Text((livestream == channels.preferredLivestream(for: channel) ? "✓ " : "") + (livestream.title ?? "Unknown"))) {
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
						} label: {
							VStack {
								Spacer()
								
								if horizontalSizeClass != .regular {
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
					Text("20:00")
					.font(.title3)
					.bold()
					
					Text("Tageschau")
					.font(.title3)
					
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
						HStack {
							Text("20:15")
							.font(.footnote)
							.bold()
							
							Text("Tatort")
							.font(.footnote)
						}
						
						HStack {
							Text("21:45")
							.font(.footnote)
							.bold()
							
							Text("Tagesthemen")
							.font(.footnote)
						}
					}
					.foregroundColor(.accentColor)
					.padding([.top, .bottom], 20)
					.padding([.leading, .trailing], 36)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(channel.secondaryColor)
				
				Spacer()
			}
			.edgesIgnoringSafeArea([.bottom])
		}
		.onAppear() {
			channels.current = channel
		}
	}
}

