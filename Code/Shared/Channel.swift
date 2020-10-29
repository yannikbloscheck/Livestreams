import Foundation
import SwiftUI


/// A channel
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
struct Channel: Identifiable, Hashable, Equatable {
	// MARK: Properties
	
	/// The id
	var id: Int
	
	
	
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
			print()
			if let asset = NSDataAsset(name: "Channels/\(id)/Livestreams"), let livestreams = try? JSONDecoder().decode([Livestream].self, from: asset.data) {
				return livestreams
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

