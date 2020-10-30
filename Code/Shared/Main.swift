import Foundation
import SwiftUI


/// Main scene for the application
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
@main
struct Main: App {
	// MARK: Properties
	
	/// The current scene phase
	@Environment(\.scenePhase) var scenePhase
	
	
	
	/// The channels
	@ObservedObject var channels: Channels = Channels.shared
	
	
	
	/// The actual scene
	var body: some Scene {
		WindowGroup {
			ChannelsView()
			.environmentObject(channels)
		}
		.onChange(of: scenePhase) { phase in
			if phase == .active {
				channels.refreshProgram()
			}
		}
	}
}

