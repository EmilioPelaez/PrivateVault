//
//  FolderShape.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 15/08/2021.
//

import SwiftUI

struct FolderShape: Shape {
	
	static let preferredAspectRatio: CGFloat = 1.2
	static let tabHeightFactor: CGFloat = 0.125
	
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let width = rect.size.width
		let height = rect.size.height
		let tabHeight = height * FolderShape.tabHeightFactor
		let cornerSize = CGSize(side: min(width, height) * 0.1)
		
		path.addRoundedRect(in: rect.inset(by: UIEdgeInsets(top: tabHeight, left: 0, bottom: 0, right: 0)), cornerSize: cornerSize)
		path.addRoundedRect(in: CGRect(x: 0, y: 0, width: width * 0.4, height: tabHeight * 2.5), cornerSize: cornerSize)
		
		path.move(to: CGPoint(x: width * 0.25, y: 0))
		path.addLine(to: CGPoint(x: width * 0.35, y: 0))
		path.addLine(to: CGPoint(x: width * 0.5, y: tabHeight))
		path.addLine(to: CGPoint(x: width * 0.35, y: tabHeight))
		
		path.closeSubpath()
		
		return path
	}
}

struct FolderShape_Previews: PreviewProvider {
	static var previews: some View {
		FolderShape()
			.folderStyle()
			.previewLayout(.fixed(width: 240, height: 200))
			.padding()
	}
}
