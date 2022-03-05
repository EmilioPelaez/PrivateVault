//
//  FolderNavigationView.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 29/08/2021.
//

import SwiftUI

struct FolderNavigationView: View {
	@EnvironmentObject private var appState: AppState
	@State var viewModel: ViewModel = .empty
	
	var body: some View {
		ScrollView(.horizontal) {
			HStack(spacing: 8) {
				homeButton
				ForEach(viewModel.intermediaryFolders) { folder in
					FolderView(folder: folder) {
						appState.currentFolder = folder
					}
				}
				if let currentFolder = viewModel.currentFolder {
					FolderView(folder: currentFolder, action: nil)
				}
			}
		}
		.frame(maxWidth: .infinity)
		.onChange(of: appState.currentFolder) { folder in
			withAnimation { viewModel = ViewModel(currentFolder: folder) }
		}
	}
}

private extension FolderNavigationView {
	struct FolderView: View {
		let folder: Folder
		let action: (() -> Void)?
		var body: some View {
			HStack(spacing: 4) {
				Image(systemName: "chevron.backward")
					.foregroundColor(.blue.opacity(0.5))
				if let action = action {
					Button(action: action) {
						title
					}
				} else {
					title
				}
			}
			.id(folder.name ?? "Identifier")
			.transition(.opacity)
		}
		
		var title: some View {
			Text(folder.name ?? "")
				.font(.subheadline)
				.bold()
		}
	}
}

private extension FolderNavigationView {
	var homeButton: some View {
		Button {
			appState.currentFolder = nil
		} label: {
			Image(systemName: "house.fill")
				.font(.title2)
		}
	}
}

struct FolderNavigationView_Previews: PreviewProvider {
	static var preview = PreviewEnvironment()
	
	static var previews: some View {
		FolderNavigationView(viewModel: .empty)
			.environmentObject(AppState())
	}
}
