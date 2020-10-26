import Foundation
import SwiftUI


/// A channel
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
struct Channel: Identifiable, Hashable, Equatable, Codable {
	// MARK: Properties
	
	/// The id
	var id: String = UUID().uuidString
	
	
	
	/// The name
	var name: String
	
	
	
	/// The logo
	var logo: Data
	
	
	
	/// The primary color
	var primaryColor: Color
	
	
	
	/// The secondary color
	var secondaryColor: Color
	
	
	
	/// The livestreams
	var livestreams: [Livestream]
	
	
	
	
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
		return lhs.id == rhs.id && lhs.name == rhs.name && lhs.logo == rhs.logo && lhs.primaryColor == rhs.primaryColor && lhs.secondaryColor == rhs.secondaryColor && lhs.livestreams == rhs.livestreams
	}
	
	
	
	
	// MARK: Codable
	
	/// The coding keys for a channel
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case logo
		case primaryColor
		case secondaryColor
		case livestreams
	}
	
	
	
	/// Initalizing a channel from a decoder
	/// - Parameter decoder: The decoder
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		id = try container.decode(String.self, forKey: .id)
		
		name = try container.decode(String.self, forKey: .name)
		
		logo = try container.decode(Data.self, forKey: .logo)
		
		if let color = Color(hexCode: try container.decode(String.self, forKey: .primaryColor)) {
			primaryColor = color
		} else {
			throw DecodingError.dataCorruptedError(forKey: .primaryColor, in: container, debugDescription: "No valid color value")
		}
		
		if let color = Color(hexCode: try container.decode(String.self, forKey: .secondaryColor)) {
			secondaryColor = color
		} else {
			throw DecodingError.dataCorruptedError(forKey: .secondaryColor, in: container, debugDescription: "No valid color value")
		}
		
		livestreams = try container.decode([Livestream].self, forKey: .livestreams)
	}
	
	
	
	/// Encode a channel
	/// - Parameter encoder: The encoder
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(id, forKey: .id)
		
		try container.encode(name, forKey: .name)
		
		try container.encode(logo, forKey: .logo)
		
		try container.encode(primaryColor.hexCode, forKey: .primaryColor)
		
		try container.encode(secondaryColor.hexCode, forKey: .secondaryColor)
		
		try container.encode(livestreams, forKey: .livestreams)
	}
}

