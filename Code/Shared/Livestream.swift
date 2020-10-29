import Foundation


/// A livestream for a channel
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
struct Livestream: Equatable, Codable {
	// MARK: Properties
	
	/// The title
	var title: String? = nil
	
	
	
	/// The url
	let url: URL
}

