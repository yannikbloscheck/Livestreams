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
	
	
	
	/// The actual scene
	var body: some Scene {
		WindowGroup {
			MainView()
		}
		.onChange(of: scenePhase) { phase in
			if phase == .active {
				/// TODO: Refresh channels
			}
		}
	}
}

