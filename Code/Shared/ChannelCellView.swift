import Foundation
import SwiftUI


/// View for a channel cell
/// - Copyright: © Yannik Bloscheck - All rights reserved
/// - Since: 2020-10-25
struct ChannelCellView: View {
	// MARK: Properties
	
	/// The channels
	@EnvironmentObject var channels: Channels
	
	
	
	/// The channel
	var channel: Channel
	
	
	
	/// The actual view
	var body: some View {
		HStack {
			channel.logo
			.resizable()
			.aspectRatio(1, contentMode: .fit)
			.frame(idealWidth: 70, idealHeight: 70)
			
			HStack {
				VStack(alignment: .trailing, spacing: 5) {
					Text(channel.currentShow?.title == nil ? "" : "Now")
					.font(.footnote)
					.bold()
					.lineLimit(1)
					
					Text(channel.nextShow?.time ?? "")
					.font(.footnote)
					.bold()
					.lineLimit(1)
				}
				.frame(minWidth: 44, idealWidth: 44, maxWidth: .infinity, alignment: .trailing)
				
				VStack(alignment: .leading, spacing: 5) {
					Text(channel.currentShow?.title ?? "")
					.lineLimit(1)
					.font(.footnote)
					.lineLimit(1)
					
					Text(channel.nextShow?.title ?? "")
					.font(.footnote)
					.lineLimit(1)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				.layoutPriority(1)
			}
		}
	}
}

