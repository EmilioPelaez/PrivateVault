//
//  FilePreview.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import SwiftUI

struct FilePreview: View {
	let image: Image
	
	var body: some View {
		GeometryReader { proxy in
			ZStack {
				Color.clear
				image
					.resizable()
					.aspectRatio(contentMode: .fit)
					.clipShape(FileShape(cornerLength: cornerLength(for: proxy.size), foldLength: foldLength(for: proxy.size)))
					.shadow(color: Color(white: 0, opacity: 0.2), radius: 4, x: 0, y: 2)
					.overlay(
						FileShape(cornerLength: cornerLength(for: proxy.size), foldLength: foldLength(for: proxy.size))
							.stroke(Color(.lightText), lineWidth: 1)
					)
					.overlay(
						FoldShape(length: foldLength(for: proxy.size))
							.fill(Color.white)
							.shadow(color: Color(white: 0, opacity: 0.1), radius: 3, x: -1, y: 1)
					)
					.overlay(
						FoldShape(length: foldLength(for: proxy.size) - 1)
							.stroke(Color(.lightText), lineWidth: 1)
							.padding(.trailing, 1)
							.padding(.top, 1)
					)
			}
			.padding()
		}
	}
	
	func foldLength(for size: CGSize) -> CGFloat {
		min(size.width, size.height) / 8
	}
	
	func cornerLength(for size: CGSize) -> CGFloat {
		min(size.width, size.height) / 40
	}
	
	struct FileShape: Shape {
		let cornerLength: CGFloat
		let foldLength: CGFloat
		
		func path(in rect: CGRect) -> Path {
			var path = Path()
			
			path.move(to: CGPoint(x: rect.maxX - foldLength, y: rect.minY))
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + foldLength))
			path.addArc(center: CGPoint(x: rect.maxX - cornerLength, y: rect.maxY - cornerLength), radius: cornerLength, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
			path.addArc(center: CGPoint(x: rect.minX + cornerLength, y: rect.maxY - cornerLength), radius: cornerLength, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
			path.addArc(center: CGPoint(x: rect.minX + cornerLength, y: rect.minX + cornerLength), radius: cornerLength, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
			path.closeSubpath()
			
			return path
		}
	}
	
	struct FoldShape: Shape {
		let length: CGFloat
		
		func path(in rect: CGRect) -> Path {
			var path = Path()
			
			path.move(to: CGPoint(x: rect.maxX - length, y: rect.minY))
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + length))
			path.addLine(to: CGPoint(x: rect.maxX - length, y: rect.minY + length))
			path.closeSubpath()
			
			return path
		}
	}
	
}

struct FilePreviewView_Previews: PreviewProvider {
	static var previews: some View {
		FilePreview(image: Image("file1"))
			.frame(maxWidth: 300, maxHeight: 300)
			.padding()
			.previewLayout(.sizeThatFits)
		
		FilePreview(image: Image("file1"))
			.frame(maxWidth: 300, maxHeight: 300)
			.padding()
			.previewLayout(.sizeThatFits)
			.colorScheme(.dark)
	}
}
