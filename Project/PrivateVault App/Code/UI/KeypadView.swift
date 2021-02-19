//
//  LockView.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/19/21.
//

import SwiftUI

struct KeypadView: View {
	var columns: [GridItem] {
		[
			GridItem(.flexible()),
			GridItem(.flexible()),
			GridItem(.flexible())
		]
	}
	
	var input: (Int) -> Void
	
    var body: some View {
		LazyVGrid(columns: columns, alignment: .center, content: {
			ForEach(1..<10){ index in
				KeyButton(title: index) {
					input(index)
				}
			}
			
			Spacer()
			KeyButton(title: 10) {
				
			}
			.aspectRatio(1, contentMode: .fill)
			.clipShape(Circle())
			Spacer()
			
		})
    }
}

struct KeyButton: View {
	var title: Int
	var action: () -> Void
	var body: some View {
		Button(action: action, label: {
			ZStack {
				Color(#colorLiteral(red: 0.7065681379, green: 0.6965085175, blue: 0.7033597253, alpha: 1))
				Text("\(title)")
					.foregroundColor(.white)
			}
		})
		.aspectRatio(1, contentMode: .fill)
		.clipShape(Circle())
	}
}


struct LockView_Previews: PreviewProvider {
    static var previews: some View {
		KeypadView(input: { _ in
			
		})
    }
}
