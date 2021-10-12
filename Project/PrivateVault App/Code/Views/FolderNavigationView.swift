//
//  FolderNavigationView.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 29/08/2021.
//

import SwiftUI

struct FolderNavigationView: View {
	@EnvironmentObject private var appState: AppState
	
	var parentFolders: [Folder] {
		var parents = [Folder]()
		var currentFolder = appState.currentFolder?.parent
		while let unwrappedFolder = currentFolder {
			parents.append(unwrappedFolder)
			currentFolder = currentFolder?.parent
		}
		return parents.reversed()
	}
	
	var body: some View {
		ScrollView(.horizontal) {
			HStack(spacing: 8) {
				homeButton
				ForEach(parentFolders) { parent in
					if !parentFolders.isEmpty {
						chevron
					}
					Button {
						appState.currentFolder = parent
					} label: {
						Text(parent.name ?? "")
							.font(.subheadline)
							.bold()
					}
				}
				currentFolderName
			}
		}
		.frame(maxWidth: .infinity)
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
	
	var currentFolderName: some View {
		HStack {
			if appState.currentFolder != nil {
				chevron
			}
			Text(appState.currentFolder?.name ?? "")
				.font(.subheadline)
				.bold()
		}
	}
	
	var chevron: some View {
		Image(systemName: "chevron.backward")
			.foregroundColor(.blue.opacity(0.5))
	}
}

struct FolderNavigationView_Previews: PreviewProvider {
	static var preview = PreviewEnvironment()
	
	static var previews: some View {
		FolderNavigationView()
			.environmentObject(AppState())
	}
}
