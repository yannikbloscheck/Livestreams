import Foundation


/// A show
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-29
struct Show: Identifiable, Equatable, Codable {
	// MARK: Properties
	
	/// The id
	var id: Date {
		get {
			return date
		}
	}
	
	
	
	/// The date
	let date: Date
	
	
	
	/// The time part of the date
	var time: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		return dateFormatter.string(from: date)
	}
	
	
	
	/// The title
	let title: String
}
