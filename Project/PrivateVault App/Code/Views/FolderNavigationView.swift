//
//  FolderNavigationView.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 29/08/2021.
//

import SwiftUI

struct FolderNavigationView: View {
	@Binding var folder: Folder?
	
	var parentFolders: [Folder] {
		var parents = [Folder]()
		var currentFolder = folder?.parent
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
						folder = parent
					} label: {
						Text(parent.name ?? "")
							.font(.subheadline)
							.bold()
					}
				}
				currentFolderName
			}
		}
		.padding(.vertical, 8)
		.padding(.horizontal, 16)
		.frame(maxWidth: .infinity)
    }
}

private extension FolderNavigationView {
	var homeButton: some View {
		Button {
			folder = nil
		} label: {
			Image(systemName: "house.fill")
		}
	}
	
	var currentFolderName: some View {
		HStack {
			if folder != nil {
				chevron
			}
			Text(folder?.name ?? "")
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
		FolderNavigationView(folder: .constant(preview.folder))
    }
}
