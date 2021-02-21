//
//  AboutView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 21/2/21.
//

import SwiftUI

struct AboutView: View {
	var body: some View {
		ScrollView(.vertical, showsIndicators: true) {
			VStack(spacing: 0) {
				HStack(alignment: .top, spacing: 20) {
					Image("Icon")
						.resizable()
						.frame(width: 120, height: 120)
						.clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
					VStack(alignment: .leading, spacing: 8) {
						Text("Private Vault")
							.bold()
							.font(.title)
						Text("Version 0.0.1")
							.font(.subheadline)
					}
					.padding(.top, 10)
					Spacer()
				}
				.padding()
				VStack(alignment: .leading, spacing: 8) {
					Text("Created by")
						.font(.headline)
					CreatorRow(name: "Emilio Peláez", title: "Programmer", links: [
						.website("http://emiliopelaez.me"),
						.twitter("http://twitter.com/EmilioPelaez"),
						.appStore("https://apps.apple.com/us/developer/emilio-pelaez/id408763858")
					])
					CreatorRow(name: "Ian Manor", title: "Programmer", links: [
						.website("https://www.ianmanor.com/portfolio"),
						.twitter("https://twitter.com/ian_manor"),
						.github("https://www.github.com/imvm")
					])
					CreatorRow(name: "Daniel Behar", title: "Programmer", links: [
						.twitter("https://twitter.com/dannybehar"),
						.github("https://github.com/DannyBehar")
					])
				}
				.padding()
			}
		}
		.navigationTitle("About")
	}
	
	struct CreatorRow: View {
		let name: String
		let title: String
		let links: [LinkType]
		
		var body: some View {
			HStack(spacing: 0) {
				VStack(alignment: .leading) {
					Text(name)
						.bold()
						.font(.title2)
					Text(title)
						.font(.subheadline)
				}
				Spacer()
				HStack(spacing: 4) {
					ForEach(links, id: \.systemName) { LinkButton(linkType: $0) }
				}
			}
			.padding()
			.background(Color(.tertiarySystemFill))
			.cornerRadius(15)
		}
		
		enum LinkType {
			case twitter(String)
			case website(String)
			case appStore(String)
			case github(String)
			
			var systemName: String {
				switch self {
				case .twitter: return "message.fill"
				case .website: return "globe"
				case .appStore: return "apps.iphone"
				case .github: return "chevron.left.slash.chevron.right"
				}
			}
			
			var color: Color {
				switch self {
				case .twitter: return Color(red: 0.11, green: 0.63, blue: 0.95)
				case .website: return .blue
				case .appStore, .github: return .black
				}
			}
			
			var size: CGFloat {
				switch self {
				case .twitter: return 18
				case .website: return 28
				case .appStore: return 22
				case .github: return 14
				}
			}
			
			var urlString: String {
				switch self {
				case .twitter(let urlString): return urlString
				case .website(let urlString): return urlString
				case .appStore(let urlString): return urlString
				case .github(let urlString): return urlString
				}
			}
		}
		
		struct LinkButton: View {
			let linkType: LinkType
			var body: some View {
				Button {
					guard let url = URL(string: linkType.urlString) else { return }
					UIApplication.shared.open(url)
				}
				label: {
					Image(systemName: linkType.systemName)
						.frame(width: 40, height: 40)
						.background(linkType.color)
						.cornerRadius(20)
						.foregroundColor(.white)
						.font(.system(size: linkType.size, weight: .regular, design: .default))
				}
			}
		}
	}
	
}

struct AboutView_Previews: PreviewProvider {
	static var previews: some View {
		AboutView()
	}
}
