import Foundation
import SwiftUI


/// Provides a extension to create a color from a hex code
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2016-07-07
extension Color {
	// MARK: Properties
	
	/// The hex code of the color
	var hexCode: String? {
		get {
			if let cgColor = cgColor, let components = cgColor.components, components.count >= 3 {
				let red = Float(components[0])
				let green = Float(components[1])
				let blue = Float(components[2])
				return "#" + String(format: "%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
			}
			
			return nil
		}
	}
	
	
	
	// MARK: Initialization
	
	/// Initalize a color with a hex code
	/// - Parameter hexCode: The hex code
	init?(hexCode: String) {
		var hexString = hexCode
		if hexString.hasPrefix("#") {
			hexString.remove(at: hexString.startIndex)
			if hexString.count == 6 {
				var hexInt: UInt64 = 0
				if Scanner(string: hexString).scanHexInt64(&hexInt) {
					let red = Double((hexInt & 0xFF0000) >> 16) / 255
					let green = Double((hexInt & 0xFF00) >> 8) / 255
					let blue = Double((hexInt & 0xFF)) / 255
					
					self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
				} else {
					return nil
				}
			} else {
				return nil
			}
		} else {
			return nil
		}
	}
}
