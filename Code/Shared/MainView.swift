import Foundation
import SwiftUI


/// Main view for the application
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
struct MainView: View {
	// MARK: Properties
	
	/// The prayers
	@ObservedObject var channels: Channels = Channels.shared
	
	
	
	/// The actual view
	var body: some View {
		ChannelsView()
		.environmentObject(channels)
	}
}

