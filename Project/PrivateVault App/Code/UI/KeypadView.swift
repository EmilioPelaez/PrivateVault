//
//  LockView.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/19/21.
//

import SwiftUI

struct KeypadView: View {
	@State private var code: String = ""
	
	var columns: [GridItem] {
		[
			GridItem(.flexible()),
			GridItem(.flexible()),
			GridItem(.flexible())
		]
	}
	
	var input: (Int) -> Void
	var delete: () -> Void
	
	var body: some View {
		VStack {
			InputDisplay(codeCount: code.count)
			
			LazyVGrid(columns: columns, alignment: .center, content: {
				ForEach(1..<10){ index in
					KeyButton(title: Text("\(index)"), color: Color(#colorLiteral(red: 0.7065681379, green: 0.6965085175, blue: 0.7033597253, alpha: 1))) {
						input(index)
						code.append("\(index)")
					}
				}
				Spacer()
				KeyButton(title: Text("0"), color: Color(#colorLiteral(red: 0.7065681379, green: 0.6965085175, blue: 0.7033597253, alpha: 1))) {
					code.append("0")
				}
				.aspectRatio(1, contentMode: .fill)
				.clipShape(Circle())
				KeyButton(title: Image(systemName: "delete.left"), color: Color(#colorLiteral(red: 0.8059458137, green: 0.1390043199, blue: 0.1966293752, alpha: 1))){
					delete()
					
					if code.count > 0 {
						code.removeLast()
					}
				}
			})
		}
		
	}
}

struct InputDisplay: View {
	var codeCount: Int
	var body: some View {
		ZStack {
			Color.white
			Text(String(repeating: "*", count: codeCount))
				.font(.largeTitle)
		}
	}
}

struct KeyButton<Body: View>: View {
	var title: Body
	var color: Color
	var action: () -> Void
	var body: some View {
		Button(action: action, label: {
			ZStack {
				color
				title
					.font(.largeTitle)
					.foregroundColor(.white)
			}
		})
		.aspectRatio(1, contentMode: .fill)
		.clipShape(Circle())
	}
}


struct LockView_Previews: PreviewProvider {
	static var previews: some View {
		KeypadView { _ in
		} delete: {
		}
	}
}
