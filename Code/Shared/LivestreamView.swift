import Foundation
import SwiftUI


/// View for a channel
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
struct LivestreamView: View {
	// MARK: Properties
	
	/// The channels
	@EnvironmentObject var channels: Channels
	
	
	
	/// The actual view
	var body: some View {
		VideoView(player: channels.player)
		.aspectRatio(16/9, contentMode: .fit)
	}
}
