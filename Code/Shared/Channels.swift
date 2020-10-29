import Foundation
import SwiftUI
import AVKit
import MediaPlayer


/// Access and modify channels
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
class Channels: NSObject, ObservableObject {
	// MARK: Properties
	
	/// Shared instance for the whole appilcation
	static let shared = Channels()
	
	
	
	/// All channels
	var all: [Channel] {
		get {
			let channelIds: [Int]
			if let storedChannelIds = UserDefaults.standard.array(forKey: "Channels") as? [Int] {
				channelIds = storedChannelIds
			} else {
				channelIds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
			}
			return channelIds.map { (channelId) -> Channel in
				return Channel(id: channelId)
			}
		}
		
		set {
			let channelIds = newValue.map { (channel) -> Int in
				return channel.id
			}
			UserDefaults.standard.setValue(channelIds, forKey: "Channels")
			DispatchQueue.main.async {
				self.objectWillChange.send()
			}
		}
	}
	
	private(set) var player: AVPlayer
	
	var current: Channel? = nil {
		didSet {
			if let channel = current {
				livestream = preferredLivestream(for: channel)
			} else {
				livestream = nil
			}
		}
	}
	
	var livestream: Livestream? = nil {
		didSet {
			if let livestream = livestream {
				if livestream != oldValue {
					player.replaceCurrentItem(with: AVPlayerItem(url: livestream.url))
					
					if isPlaying {
						player.play()
					}
					
					refreshNowPlaying()
				}
			} else {
				player.replaceCurrentItem(with: nil)
			}
		}
	}
	
	
	var isPlaying = false {
		didSet {
			if isPlaying {
				MPRemoteCommandCenter.shared().playCommand.isEnabled = false
				
				MPRemoteCommandCenter.shared().pauseCommand.isEnabled = true
			} else {
				MPRemoteCommandCenter.shared().playCommand.isEnabled = true
				
				MPRemoteCommandCenter.shared().pauseCommand.isEnabled = false
			}
		}
	}
	
	
	func refreshNowPlaying() {
		if let channel = current, let livestream = livestream {
			let cover = MPMediaItemArtwork(boundsSize: CGSize(width: 600, height: 600)) { (_) -> UIImage in
				return channel.cover
			}
			
			if let title = livestream.title {
				MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPNowPlayingInfoPropertyIsLiveStream:true, MPMediaItemPropertyTitle: channel.name, MPMediaItemPropertyArtist: title , MPMediaItemPropertyArtwork: cover]
			} else {
				MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPNowPlayingInfoPropertyIsLiveStream:true, MPMediaItemPropertyTitle: channel.name, MPMediaItemPropertyArtwork: cover]
			}
		}
	}
	
	
	
	/// The preferred livestream
	func preferredLivestream(for channel: Channel) -> Livestream {
		if let preferredVersionTitles = UserDefaults.standard.dictionary(forKey: "Preferred Versions") as? [String:String], let preferredVersionTitle = preferredVersionTitles[String(channel.id)] {
			var versions = channel.livestreams
			versions.removeAll { (livestream) -> Bool in
				return livestream.title != preferredVersionTitle
			}
			if let preferredVersion = versions.first {
				return preferredVersion
			}
		}
		
		return channel.livestreams.first!
	}
	
	func preferLivestream(_ livestream: Livestream, for channel: Channel) {
		var preferredVersionTitles: [String:String] = [:]
		if let currentPreferredVersionTitles = UserDefaults.standard.dictionary(forKey: "Preferred Versions") as? [String:String] {
			preferredVersionTitles = currentPreferredVersionTitles
		}
		preferredVersionTitles[String(channel.id)] = livestream.title
		
		UserDefaults.standard.setValue(preferredVersionTitles, forKey: "Preferred Versions")
	}
	
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "rate", let player = object as? AVPlayer {
			if isPlaying == true, player.rate == 0 {
				isPlaying = false
			} else if isPlaying == false, player.rate > 0 {
				isPlaying = true
			}
			
			refreshNowPlaying()
		}
	}
	
	
	// MARK: Initialization
	
	/// Initalizing
	private override init() {
		player = AVPlayer()
		
		super.init()
		
		player.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
		
		if let first = all.first {
			current = first
		}
		
		UIApplication.shared.beginReceivingRemoteControlEvents()
		
		MPRemoteCommandCenter.shared().previousTrackCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
			return MPRemoteCommandHandlerStatus.noActionableNowPlayingItem
		}
		MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = false
		
		MPRemoteCommandCenter.shared().nextTrackCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
			return MPRemoteCommandHandlerStatus.noActionableNowPlayingItem
		}
		MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = false
		
		MPRemoteCommandCenter.shared().playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
			if self.player.currentItem == nil {
				return MPRemoteCommandHandlerStatus.noActionableNowPlayingItem
			}
			
			self.player.play()
			return MPRemoteCommandHandlerStatus.success
		}
		MPRemoteCommandCenter.shared().playCommand.isEnabled = false
		
		MPRemoteCommandCenter.shared().pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
			if self.player.currentItem == nil {
				return MPRemoteCommandHandlerStatus.noActionableNowPlayingItem
			}
			
			self.player.pause()
			return MPRemoteCommandHandlerStatus.success
		}
		MPRemoteCommandCenter.shared().pauseCommand.isEnabled = false
		
		try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
	}
	
	
	deinit {
		player.removeObserver(self, forKeyPath: "rate")
		
		player.replaceCurrentItem(with: nil)
		
		MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
		
		UIApplication.shared.endReceivingRemoteControlEvents()
	}
}

