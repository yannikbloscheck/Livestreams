import Foundation
import SwiftUI


/// View for a channels
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
struct ChannelsView: View {
	// MARK: Properties
	
	/// The prayers
	@ObservedObject var channels: Channels
	
	
	
	/// The actual view
	var body: some View {
		NavigationView {
			List(channels.all) { channel in
				NavigationLink(destination: ChannelView(channel: channel)) {
					Text(channel.name)
				}
			}.navigationBarTitle("Channels")
		}
	}
}

