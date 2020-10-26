import Foundation


/// Access and modify channels
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
class Channels: ObservableObject {
	// MARK: Properties
	
	/// Shared instance for the whole appilcation
	static let shared = Channels()
	
	
	
	/// Cached version of the date of the last modification for faster access
	private var modifiedCache: Date? = nil
	
	
	
	/// The date of the last modification
	var modified: Date {
		get {
			if let date = modifiedCache {
				return date
			} else if let synced = UserDefaults.standard.object(forKey: "Modified") as? Date {
				return synced
			} else {
			   let date: Date = Date()
			   UserDefaults.standard.setValue(date, forKey: "Modified")
			   return date
			}
		}
		
		
		set (date) {
			modifiedCache = date
			
			UserDefaults.standard.setValue(date, forKey: "Modified")
		}
	}
	
	
	
	/// Cached version of all channels for faster access
	private var allCache: [Channel]? = nil
	
	
	
	/// All channels
	var all: [Channel] {
		get {
			if let channels = allCache {
				return channels
			} else if let encodedChannels = UserDefaults.standard.object(forKey: "Channels") as? Data {
				if let channels = try? PropertyListDecoder().decode(Array<Channel>.self, from: encodedChannels) {
					return channels
				} else {
					fatalError("Couldn't decode channels from user defaults")
				}
			} else {
				let channels: [Channel] = []
			    if let encodedChannels = try? PropertyListEncoder().encode(channels) {
					UserDefaults.standard.setValue(encodedChannels, forKey: "Channels")
				    return channels
			    } else {
				    fatalError("Couldn't encode default channels for user defaults")
			    }
		   }
		}
		
		
		set (channels) {
			if self.all != channels {
				modified = Date()
				
				allCache = channels
				
				DispatchQueue.main.sync {
					self.objectWillChange.send()
				}
				
				if let encodedChannels = try? PropertyListEncoder().encode(channels) {
					UserDefaults.standard.setValue(encodedChannels, forKey: "Channels")
				} else {
					fatalError("Couldn't encode channels for user defaults")
				}
			}
		}
	}
	
	
	
	// MARK: Initialization
	
	/// Initalizing
	private init() {}
}

