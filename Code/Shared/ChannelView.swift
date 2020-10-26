import Foundation
import SwiftUI


/// View for a channel
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
struct ChannelView: View {
	// MARK: Properties
	
	/// The channel
	let channel: Channel
	
	
	
	/// The actual view
	var body: some View {
		Text(channel.name)
	}
}

