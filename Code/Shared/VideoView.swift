import Foundation
import SwiftUI
import AVKit


/// View for a video
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-28
struct VideoView: UIViewControllerRepresentable {
	// MARK: Properties
	
	/// The player
	var player: AVPlayer
	
	
	
	/// Create video controller
	/// - Parameter context: The context
	/// - Returns: The video controller
	func makeUIViewController(context: Context) -> AVPlayerViewController {
		let playerController =  AVPlayerViewController()
		playerController.player = player
		playerController.updatesNowPlayingInfoCenter = false
		return playerController
	}
	
	
	
	/// Update the video controller
	/// - Parameter playerController: The video controller
	/// - Parameter context: The context
	func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
		// Do nothing
	}
}
