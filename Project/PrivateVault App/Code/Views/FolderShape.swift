//
//  FolderShape.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 15/08/2021.
//

import SwiftUI

struct FolderShape: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let width = rect.size.width
		let height = rect.size.height
		
		path.move(to: CGPoint(x: 0.83333 * width, y: 0.25 * height))
		path.addLine(to: CGPoint(x: 0.45833 * width, y: 0.25 * height))
		path.addLine(to: CGPoint(x: 0.375 * width, y: 0.16667 * height))
		path.addLine(to: CGPoint(x: 0.16667 * width, y: 0.16667 * height))
		path.addCurve(to: CGPoint(x: 0.08333 * width, y: 0.25 * height), control1: CGPoint(x: 0.12083 * width, y: 0.16667 * height), control2: CGPoint(x: 0.08333 * width, y: 0.20417 * height))
		path.addLine(to: CGPoint(x: 0.08333 * width, y: 0.41667 * height))
		path.addLine(to: CGPoint(x: 0.91667 * width, y: 0.41667 * height))
		path.addLine(to: CGPoint(x: 0.91667 * width, y: 0.33333 * height))
		path.addCurve(to: CGPoint(x: 0.83333 * width, y: 0.25 * height), control1: CGPoint(x: 0.91667 * width, y: 0.2875 * height), control2: CGPoint(x: 0.87917 * width, y: 0.25 * height))
		
		path.closeSubpath()
		
		path.move(to: CGPoint(x: 0.83333 * width, y: 0.25 * height))
		path.addLine(to: CGPoint(x: 0.16667 * width, y: 0.25 * height))
		path.addCurve(to: CGPoint(x: 0.08333 * width, y: 0.33333 * height), control1: CGPoint(x: 0.12083 * width, y: 0.25 * height), control2: CGPoint(x: 0.08333 * width, y: 0.2875 * height))
		path.addLine(to: CGPoint(x: 0.08333 * width, y: 0.75 * height))
		path.addCurve(to: CGPoint(x: 0.16667 * width, y: 0.83333 * height), control1: CGPoint(x: 0.08333 * width, y: 0.79583 * height), control2: CGPoint(x: 0.12083 * width, y: 0.83333 * height))
		path.addLine(to: CGPoint(x: 0.83333 * width, y: 0.83333 * height))
		path.addCurve(to: CGPoint(x: 0.91667 * width, y: 0.75 * height), control1: CGPoint(x: 0.87917 * width, y: 0.83333 * height), control2: CGPoint(x: 0.91667 * width, y: 0.79583 * height))
		path.addLine(to: CGPoint(x: 0.91667 * width, y: 0.33333 * height))
		path.addCurve(to: CGPoint(x: 0.83333 * width, y: 0.25 * height), control1: CGPoint(x: 0.91667 * width, y: 0.2875 * height), control2: CGPoint(x: 0.87917 * width, y: 0.25 * height))
		
		path.closeSubpath()
		
		return path
	}
}

struct FolderShape_Previews: PreviewProvider {
	static var previews: some View {
		FolderShape()
			.folderStyle()
			.previewLayout(.fixed(width: 200, height: 200))
	}
}
