import Foundation
import SwiftUI


/// A channel
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
struct Channel: Identifiable, Hashable, Equatable {
	// MARK: Properties
	
	/// The id
	let id: Int
	
	
	
	/// The name
	var name: String {
		get {
			if let asset = NSDataAsset(name: "Channels/\(id)/Name"), let name = String(data: asset.data, encoding: .utf8) {
				return name
			}
			
			return "Unknown"
		}
	}
	
	
	
	/// The logo
	var logo: Image {
		get {
			return Image("Channels/\(id)/Logo")
		}
	}
	
	
	
	/// The cover
	var cover: UIImage {
		get {
			return UIImage(named: "Channels/\(id)/Cover") ?? UIImage()
		}
	}
	
	
	
	/// The primary color
	var primaryColor: Color {
		get {
			return Color("Channels/\(id)/Primary Color")
		}
	}
	
	
	
	/// The secondary color
	var secondaryColor: Color {
		get {
			return Color("Channels/\(id)/Secondary Color")
		}
	}
	
	
	
	/// The livestreams
	var livestreams: [Livestream] {
		get {
			if let asset = NSDataAsset(name: "Channels/\(id)/Livestreams"), let livestreams = try? JSONDecoder().decode([Livestream].self, from: asset.data) {
				return livestreams
			}
			
			return []
		}
	}
	
	
	
	/// The preferred livestream
	var preferredLivestream: Livestream {
		get {
			if let preferredVersionTitles = UserDefaults.standard.dictionary(forKey: "Preferred Versions") as? [String:String], let preferredVersionTitle = preferredVersionTitles[String(id)] {
				var versions = livestreams
				versions.removeAll { (livestream) -> Bool in
					return livestream.title != preferredVersionTitle
				}
				if let preferredVersion = versions.first {
					return preferredVersion
				}
			}
			
			return livestreams.first!
		}
	}
	
	
	
	/// The program
	private var program: [Show] {
		get {
			if let programDefaults = UserDefaults(suiteName: "com.yannikbloscheck.Livestreams.Program"), let programData = programDefaults.data(forKey: "Channels"), let program = try? PropertyListDecoder().decode(Dictionary<String,Array<Show>>.self, from: programData), let shows = program[String(id)] {
				var currentAndNextShows: [Show] = []
				for i in 0..<shows.count {
					if Date(timeIntervalSinceNow: 30) < shows[i].date {
						if currentAndNextShows.isEmpty, !shows.isEmpty, i > 0 {
							currentAndNextShows.append(shows[i-1])
						}
						currentAndNextShows.append(shows[i])
					}
				}
				if currentAndNextShows.isEmpty, !shows.isEmpty, let show = shows.first {
					currentAndNextShows.append(show)
				}
				return currentAndNextShows
			}
			
			return []
		}
	}
	
	
	
	/// The current show
	var currentShow: Show? {
		get {
			if let show = program.first {
				return show
			}
			
			return nil
		}
	}
	
	
	
	/// The next show
	var nextShow: Show? {
		get {
			if program.count > 1, let show = program.suffix(from: 1).first {
				return show
			}
			
			return nil
		}
	}
	
	
	
	/// The next shows
	var nextShows: [Show] {
		get {
			if program.count > 1 {
				return Array(program.suffix(from: 1))
			}
			
			return []
		}
	}
	
	
	
	
	// MARK: Hashable
	
	/// Hash a channel with a hasher
	/// - Parameter hasher: The hasher
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	
	
	
	// MARK: Equatable
	
	/// Check if two channels are the same
	/// - Parameter lhs: The left channel
	/// - Parameter rhs: The right channel
	/// - Returns: If both channels are the same
	static func == (lhs: Channel, rhs: Channel) -> Bool {
		return lhs.id == rhs.id
	}
}

