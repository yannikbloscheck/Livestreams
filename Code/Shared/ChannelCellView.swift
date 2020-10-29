import Foundation
import SwiftUI


/// View for a channel cell
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
struct ChannelCellView: View {
	// MARK: Properties
	
	/// The channel
	var channel: Channel
	
	
	
	/// The actual view
	var body: some View {
		HStack {
			channel.logo
			.resizable()
			.aspectRatio(1, contentMode: .fit)
			.frame(idealWidth: 70, idealHeight: 70)
			
			VStack(alignment: .leading, spacing: 5) {
				HStack {
					Text("20:00")
					.font(.footnote)
					.bold()
					
					Text("Tageschau")
					.font(.footnote)
				}
				
				HStack {
					Text("20:15")
					.font(.footnote)
					.bold()
					
					Text("Tatort")
					.font(.footnote)
				}
			}
		}
	}
}

